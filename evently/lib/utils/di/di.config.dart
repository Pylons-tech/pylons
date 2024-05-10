// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:evently/evently_provider.dart' as _i10;
import 'package:evently/repository/repository.dart' as _i9;
import 'package:evently/services/datasources/local_datasource.dart' as _i6;
import 'package:evently/utils/di/register_modules.dart' as _i11;
import 'package:evently/utils/file_utils_helper.dart' as _i8;
import 'package:evently/viewmodels/create_event_viewmodel.dart' as _i3;
import 'package:file_picker/file_picker.dart' as _i5;
import 'package:get_it/get_it.dart' as _i1;
import 'package:image_cropper/image_cropper.dart' as _i4;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_preferences/shared_preferences.dart' as _i7;

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
    gh.lazySingleton<_i6.LocalDataSource>(() => _i6.LocalDataSourceImpl(
        sharedPreferences: gh<_i7.SharedPreferences>()));
    gh.lazySingleton<_i8.FileUtilsHelper>(() => _i8.FileUtilsHelperImpl(
          imageCropper: gh<_i4.ImageCropper>(),
          filePicker: gh<_i5.FilePicker>(),
        ));
    gh.lazySingleton<_i9.Repository>(() => _i9.RepositoryImp(
          fileUtilsHelper: gh<_i8.FileUtilsHelper>(),
          localDataSource: gh<_i6.LocalDataSource>(),
        ));
    gh.lazySingleton<_i10.EventlyProvider>(
        () => _i10.EventlyProvider(repository: gh<_i9.Repository>()));
    return this;
  }
}

class _$RegisterModule extends _i11.RegisterModule {}
