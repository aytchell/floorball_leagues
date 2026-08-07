import 'package:bloc/bloc.dart';
import 'package:floorball/api/models/ref_license.dart';
import 'package:floorball/repositories/api_repository.dart';
import 'package:logging/logging.dart';

final log = Logger('RefLicenseCubit');

class RefLicenseState {
  final Map<int, RefLicense> _licenses;

  RefLicenseState() : _licenses = {};

  RefLicenseState._(Map<int, RefLicense> licenses) : _licenses = licenses;

  bool hasRefId(int refereeId) => _licenses[refereeId] != null;

  RefLicense? getLicense(int licenseId) => _licenses[licenseId];

  RefLicenseState copyWith(int refereeId, RefLicense license) {
    final newLicensesMap = Map<int, RefLicense>.fromEntries(_licenses.entries);
    newLicensesMap.addEntries([MapEntry(refereeId, license)]);

    return RefLicenseState._(newLicensesMap);
  }
}

class RefLicenseCubit extends Cubit<RefLicenseState> {
  final ApiRepository _repo;

  RefLicenseCubit(ApiRepository repo) : _repo = repo, super(RefLicenseState());

  void ensureRefId(int refereeId) {
    if (state.hasRefId(refereeId)) {
      // license information for referees doesn't change that often
      // so we only fetch it once per app run
      return;
    }

    _repo
        .getRefLicense(refereeId)
        .then(
          (stream) => stream.forEach(
            (license) =>
                emit(state.copyWith(refereeId = refereeId, license = license)),
          ),
        );
  }
}
