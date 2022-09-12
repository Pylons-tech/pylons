import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/model/nft.dart';
import 'package:pylons_wallet/pages/detailed_asset_view/owner_view.dart';
import 'package:pylons_wallet/pages/home/collection_screen/collection_view_model.dart';
import 'package:pylons_wallet/utils/dependency_injection/dependency_injection.dart';
import 'package:pylons_wallet/utils/enums.dart';

class GesturesForDetailsScreen extends StatefulWidget {
  final Widget child;
  final DetailScreen screen;
  final NFT nft;
  final dynamic viewModel;
  final Function(TapUpDetails)? tapUp;

  const GesturesForDetailsScreen({Key? key, required this.child, required this.screen, required this.nft, required this.viewModel, this.tapUp}) : super(key: key);

  @override
  State<GesturesForDetailsScreen> createState() => _GesturesForDetailsScreenState();
}

class _GesturesForDetailsScreenState extends State<GesturesForDetailsScreen> {
  Offset? _initialSwipeOffset;
  Offset? _finalSwipeOffset;
  SwipeDirection? _previousDirection;
  SimpleSwipeConfig swipeConfig = const SimpleSwipeConfig();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: widget.tapUp,
      onHorizontalDragUpdate: widget.screen == DetailScreen.ownerScreen ? _onHorizontalDragUpdate : null,
      onHorizontalDragEnd: widget.screen == DetailScreen.ownerScreen ? _onHorizontalDragEnd : null,
      onHorizontalDragStart: widget.screen == DetailScreen.ownerScreen ? _onHorizontalDragStart : null,
      onVerticalDragUpdate: _onVerticalDragUpdate,
      onVerticalDragEnd: _onVerticalDragEnd,
      onVerticalDragStart: _onVerticalDragStart,
      onLongPressStart: _onLongPressStart,
      onLongPressEnd: _onLongPressEnd,
      child: widget.child,
    );
  }

  void _onVerticalDragStart(DragStartDetails details) {
    _initialSwipeOffset = details.globalPosition;
  }

  void _onLongPressStart(LongPressStartDetails details) {
    if (widget.screen == DetailScreen.ownerScreen) {
      if (widget.viewModel!.collapsed == true) {
        if (details.globalPosition.dy < 745) {
          widget.viewModel!.isViewingFullNft = true;
        }
        return;
      }
      if (details.globalPosition.dy < 575) {
        widget.viewModel!.isViewingFullNft = true;
      }
      if (details.globalPosition.dx > 210 && details.globalPosition.dx < 320) {
        widget.viewModel!.isViewingFullNft = true;
      }
      return;
    }
    if (widget.viewModel!.collapsed == true) {
      if (details.globalPosition.dy < 745) {
        widget.viewModel!.isViewingFullNft = true;
      }
      return;
    }
    if (details.globalPosition.dy < 575) {
      widget.viewModel!.isViewingFullNft = true;
    }
    if (details.globalPosition.dx > 210 && details.globalPosition.dx < 320) {
      widget.viewModel!.isViewingFullNft = true;
    }
  }

  void _onLongPressEnd(LongPressEndDetails details) {
    widget.viewModel!.isViewingFullNft = false;
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    _finalSwipeOffset = details.globalPosition;

    if (swipeConfig.swipeDetectionBehavior == SwipeDetectionBehavior.singularOnEnd) {
      return;
    }

    final initialOffset = _initialSwipeOffset;
    final finalOffset = _finalSwipeOffset;

    if (initialOffset != null && finalOffset != null) {
      final offsetDifference = initialOffset.dy - finalOffset.dy;

      if (offsetDifference.abs() > swipeConfig.verticalThreshold) {
        _initialSwipeOffset = swipeConfig.swipeDetectionBehavior == SwipeDetectionBehavior.singular ? null : _finalSwipeOffset;

        final direction = offsetDifference > 0 ? SwipeDirection.up : SwipeDirection.down;

        if (swipeConfig.swipeDetectionBehavior == SwipeDetectionBehavior.continuous || _previousDirection == null || direction != _previousDirection) {
          _previousDirection = direction;
        }
      }
    }
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    if (swipeConfig.swipeDetectionBehavior == SwipeDetectionBehavior.singularOnEnd) {
      final initialOffset = _initialSwipeOffset;
      final finalOffset = _finalSwipeOffset;

      if (initialOffset != null && finalOffset != null) {
        final offsetDifference = initialOffset.dy - finalOffset.dy;

        if (offsetDifference.abs() > swipeConfig.verticalThreshold) {
          final direction = offsetDifference > 0 ? SwipeDirection.up : SwipeDirection.down;
          if (direction == SwipeDirection.up) {
            widget.viewModel!.collapsed = false;
            return;
          }
          widget.viewModel!.collapsed = true;
        }
      }
    }

    _initialSwipeOffset = null;
    _previousDirection = null;
  }

  void _onHorizontalDragStart(DragStartDetails details) {
    _initialSwipeOffset = details.globalPosition;
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    _finalSwipeOffset = details.globalPosition;

    if (swipeConfig.swipeDetectionBehavior == SwipeDetectionBehavior.singularOnEnd) {
      return;
    }

    final initialOffset = _initialSwipeOffset;
    final finalOffset = _finalSwipeOffset;

    if (initialOffset != null && finalOffset != null) {
      final offsetDifference = initialOffset.dx - finalOffset.dx;

      if (offsetDifference.abs() > swipeConfig.horizontalThreshold) {
        _initialSwipeOffset = swipeConfig.swipeDetectionBehavior == SwipeDetectionBehavior.singular ? null : _finalSwipeOffset;

        final direction = offsetDifference > 0 ? SwipeDirection.left : SwipeDirection.right;

        if (swipeConfig.swipeDetectionBehavior == SwipeDetectionBehavior.continuous || _previousDirection == null || direction != _previousDirection) {
          _previousDirection = direction;
        }
      }
    }
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (widget.screen == DetailScreen.ownerScreen) {
      if (swipeConfig.swipeDetectionBehavior == SwipeDetectionBehavior.singularOnEnd) {
        final initialOffset = _initialSwipeOffset;
        final finalOffset = _finalSwipeOffset;

        if (initialOffset != null && finalOffset != null) {
          final offsetDifference = initialOffset.dx - finalOffset.dx;

          if (offsetDifference.abs() > swipeConfig.horizontalThreshold) {
            final direction = offsetDifference > 0 ? SwipeDirection.left : SwipeDirection.right;
            if (direction == SwipeDirection.left) {
              navigateToNextNft();
              return;
            }
            navigateToPreviousNft();
          }
        }
      }

      _initialSwipeOffset = null;
      _previousDirection = null;
      return;
    }
  }

  void navigateToNextNft() {
    final collectionViewModel = GetIt.I.get<CollectionViewModel>();
    if (widget.nft.type == NftType.TYPE_RECIPE) {
      int index = collectionViewModel.creations.indexOf(widget.nft);

      if (collectionViewModel.creations.length - 1 == index) return;
      index = index + 1;
      final NFT nft = collectionViewModel.creations.elementAt(index);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => OwnerView(
            nft: nft,
            ownerViewViewModel: sl(),
          ),
        ),
      );
    }
    if (widget.nft.type == NftType.TYPE_ITEM) {
      int index = collectionViewModel.purchases.indexOf(widget.nft);

      if (collectionViewModel.purchases.length - 1 == index) return;
      index = index + 1;
      final NFT nft = collectionViewModel.purchases.elementAt(index);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => OwnerView(
            nft: nft,
            ownerViewViewModel: sl(),
          ),
        ),
      );
    }
  }

  void navigateToPreviousNft() {
    final collectionViewModel = GetIt.I.get<CollectionViewModel>();
    if (widget.nft.type == NftType.TYPE_RECIPE) {
      int index = collectionViewModel.creations.indexOf(widget.nft);

      if (index == 0) return;
      index = index - 1;
      final NFT nft = collectionViewModel.creations.elementAt(index);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => OwnerView(
            nft: nft,
            ownerViewViewModel: sl(),
          ),
        ),
      );
    }
    if (widget.nft.type == NftType.TYPE_ITEM) {
      int index = collectionViewModel.purchases.indexOf(widget.nft);

      if (index == 0) return;
      index = index - 1;
      final NFT nft = collectionViewModel.purchases.elementAt(index);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => OwnerView(
            nft: nft,
            ownerViewViewModel: sl(),
          ),
        ),
      );
    }
  }
}

enum DetailScreen { ownerScreen, purchaseScreen }

enum SwipeDetectionBehavior {
  singular,
  singularOnEnd,
  continuous,
  continuousDistinct,
}

class SimpleSwipeConfig {
  final double verticalThreshold;

  final double horizontalThreshold;

  final SwipeDetectionBehavior swipeDetectionBehavior;

  const SimpleSwipeConfig({
    this.verticalThreshold = 50.0,
    this.horizontalThreshold = 50.0,
    this.swipeDetectionBehavior = SwipeDetectionBehavior.singularOnEnd,
  });
}

enum SwipeDirection { left, right, up, down }
