// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i6;
import 'package:evently/evently_provider.dart' as _i13;
import 'package:evently/repository/repository.dart' as _i12;
import 'package:evently/services/datasources/local_datasource.dart' as _i7;
import 'package:evently/services/datasources/remote_datasource.dart' as _i11;
import 'package:evently/services/third_party_services/quick_node.dart' as _i10;
import 'package:evently/utils/di/register_modules.dart' as _i14;
import 'package:evently/utils/file_utils_helper.dart' as _i9;
import 'package:evently/viewmodels/create_event_viewmodel.dart' as _i3;
import 'package:file_picker/file_picker.dart' as _i5;
import 'package:get_it/get_it.dart' as _i1;
import 'package:image_cropper/image_cropper.dart' as _i4;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_preferences/shared_preferences.dart' as _i8;

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
    gh.lazySingleton<_i3.CreateEventViewModel>(
        () => _i3.CreateEventViewModel());
    gh.lazySingleton<_i4.ImageCropper>(() => registerModule.imageCropper);
    gh.lazySingleton<_i5.FilePicker>(() => registerModule.filePicker);
    gh.lazySingleton<_i6.Dio>(() => registerModule.dio);
    gh.lazySingleton<_i7.LocalDataSource>(() => _i7.LocalDataSourceImpl(
        sharedPreferences: gh<_i8.SharedPreferences>()));
    gh.lazySingleton<_i9.FileUtilsHelper>(() => _i9.FileUtilsHelperImpl(
          imageCropper: gh<_i4.ImageCropper>(),
          filePicker: gh<_i5.FilePicker>(),
        ));
    gh.lazySingleton<_i10.QuickNode>(
        () => _i10.QuickNodeImpl(httpClient: gh<_i6.Dio>()));
    gh.lazySingleton<_i11.RemoteDataSource>(
        () => _i11.RemoteDataSourceImpl(quickNode: gh<_i10.QuickNode>()));
    gh.lazySingleton<_i12.Repository>(() => _i12.RepositoryImp(
          fileUtilsHelper: gh<_i9.FileUtilsHelper>(),
          localDataSource: gh<_i7.LocalDataSource>(),
          remoteDataSource: gh<_i11.RemoteDataSource>(),
        ));
    gh.lazySingleton<_i13.EventlyProvider>(
        () => _i13.EventlyProvider(repository: gh<_i12.Repository>()));
    return this;
  }
}

class _$RegisterModule extends _i14.RegisterModule {}
