// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i5;
import 'package:evently/evently_provider.dart' as _i14;
import 'package:evently/repository/repository.dart' as _i13;
import 'package:evently/screens/event_hub/event_hub_view_model.dart' as _i16;
import 'package:evently/services/datasources/cache_manager.dart' as _i6;
import 'package:evently/services/datasources/local_datasource.dart' as _i9;
import 'package:evently/services/datasources/remote_datasource.dart' as _i12;
import 'package:evently/services/third_party_services/database.dart' as _i11;
import 'package:evently/services/third_party_services/quick_node.dart' as _i8;
import 'package:evently/utils/di/register_modules.dart' as _i17;
import 'package:evently/utils/file_utils_helper.dart' as _i7;
import 'package:evently/viewmodels/create_event_viewmodel.dart' as _i15;
import 'package:file_picker/file_picker.dart' as _i4;
import 'package:get_it/get_it.dart' as _i1;
import 'package:image_cropper/image_cropper.dart' as _i3;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_preferences/shared_preferences.dart' as _i10;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i3.ImageCropper>(() => registerModule.imageCropper);
    gh.lazySingleton<_i4.FilePicker>(() => registerModule.filePicker);
    gh.lazySingleton<_i5.Dio>(() => registerModule.dio);
    gh.lazySingleton<_i6.CacheManager>(() => _i6.CacheManagerImp());
    gh.lazySingleton<_i7.FileUtilsHelper>(() => _i7.FileUtilsHelperImpl(
          imageCropper: gh<_i3.ImageCropper>(),
          filePicker: gh<_i4.FilePicker>(),
        ));
    gh.lazySingleton<_i8.QuickNode>(
        () => _i8.QuickNodeImpl(httpClient: gh<_i5.Dio>()));
    gh.lazySingleton<_i9.LocalDataSource>(() => _i9.LocalDataSourceImpl(
          sharedPreferences: gh<_i10.SharedPreferences>(),
          database: gh<_i11.AppDatabase>(),
          cacheManager: gh<_i6.CacheManager>(),
        ));
    gh.lazySingleton<_i12.RemoteDataSource>(
        () => _i12.RemoteDataSourceImpl(quickNode: gh<_i8.QuickNode>()));
    gh.lazySingleton<_i13.Repository>(() => _i13.RepositoryImp(
          fileUtilsHelper: gh<_i7.FileUtilsHelper>(),
          localDataSource: gh<_i9.LocalDataSource>(),
          remoteDataSource: gh<_i12.RemoteDataSource>(),
        ));
    gh.lazySingleton<_i14.EventlyProvider>(
        () => _i14.EventlyProvider(repository: gh<_i13.Repository>()));
    gh.lazySingleton<_i15.CreateEventViewModel>(
        () => _i15.CreateEventViewModel(gh<_i13.Repository>()));
    gh.lazySingleton<_i16.EventHubViewModel>(
        () => _i16.EventHubViewModel(gh<_i13.Repository>()));
    return this;
  }
}

class _$RegisterModule extends _i17.RegisterModule {}
