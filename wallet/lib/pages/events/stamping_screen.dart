import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/pages/detailed_asset_view/owner_view_view_model.dart';
import '../../model/common.dart';
import '../../model/event.dart';
import '../../stores/wallet_store.dart';

class StampingScreen extends StatefulWidget {
  final String cookbookId;
  final String recipeId;
  final String challenge;
  final OwnerViewViewModel ownerViewViewModel;
  final Events event;

  const StampingScreen({
    super.key,
    required this.cookbookId,
    required this.recipeId,
    required this.challenge,
    required this.ownerViewViewModel,
    required this.event,
  });

  @override
  _StampingScreenState createState() => _StampingScreenState();
}

class _StampingScreenState extends State<StampingScreen> {
  Events? event;
  late OwnerViewViewModel ownerViewViewModel;
  bool isLoading = true;
  bool isAlreadyStamped = false;

  @override
  void initState() {
    super.initState();
    ownerViewViewModel = GetIt.I.get<OwnerViewViewModel>();
    fetchEvent();
  }

  Future<void> fetchEvent() async {
    try {
      final fetchedEvent = await eventFromRecipeId(widget.cookbookId, widget.recipeId);

      if (mounted) {
        setState(() {
          event = fetchedEvent;
          isLoading = false;
          isAlreadyStamped = widget.challenge.isNotEmpty;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch event: $e')),
      );
    }
  }

  Future<void> _stampTicket(BuildContext context) async {
    try {
      if (isAlreadyStamped) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('This ticket is already stamped.')),
        );
        return;
      }

      await ownerViewViewModel.stampTicket(
        cookbookId: widget.cookbookId,
        recipeId: widget.recipeId,
        creatorAddress: Address(widget.ownerViewViewModel.owner),
        challenge: widget.challenge,
      );

      final updatedEvent = await eventFromRecipeId(widget.cookbookId, widget.recipeId);

      if (mounted) {
        setState(() {
          event = updatedEvent;
          isAlreadyStamped = true;
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ticket with challenge ${widget.challenge} stamped successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to stamp ticket: $e')),
      );
    }
  }

  Future<Events?> eventFromRecipeId(String cookbookId, String recipeId) async {
    final walletsStore = GetIt.I.get<WalletsStore>();
    final recipeEither = await walletsStore.getRecipe(cookbookId, recipeId);

    if (recipeEither.isLeft()) {
      return null;
    }

    return Events.fromRecipe(recipeEither.toOption().toNullable()!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stamp Ticket')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : event == null
          ? const Center(child: Text('No event found for the provided IDs.'))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: event!.thumbnail,
              height: 200.h,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            const SizedBox(height: 16),
            Text(
              event!.eventName,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              event!.description,
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Cookbook ID: ${widget.cookbookId}\nRecipe ID: ${widget.recipeId}\nChallenge: ${widget.challenge}',
              style: TextStyle(fontSize: 18.sp),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () => _stampTicket(context),
                child: const Text('Stamp Ticket'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
