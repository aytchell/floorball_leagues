import 'package:bloc/bloc.dart';
import 'package:floorball/repositories/ref_license_repository.dart';
import 'package:logging/logging.dart';

final log = Logger('RefLicenseBloc');

class RefLicenseState {
  final Map<int, RefLicense> _licenses;

  RefLicenseState(this._licenses);

  RefLicense? getLicense(int licenseId) => _licenses[licenseId];
}

class _LoadCsvEvent {}

class RefLicenseBloc extends Bloc<_LoadCsvEvent, RefLicenseState> {
  final RefLicenseRepository _repo;

  RefLicenseBloc(this._repo) : super(RefLicenseState({})) {
    on<_LoadCsvEvent>(
      (event, emit) => _repo.licenses
          .then((csv) => emit(RefLicenseState(csv)))
          .catchError((error) {
            log.severe('Error loading licenses: $error');
            emit(RefLicenseState({}));
          }),
    );
  }

  factory RefLicenseBloc.create(RefLicenseRepository repo) {
    final bloc = RefLicenseBloc(repo);
    bloc.add(_LoadCsvEvent());
    return bloc;
  }
}
