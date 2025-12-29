import 'package:bloc/bloc.dart';
import 'package:logging/logging.dart';
import '../models/season_info.dart';

final log = Logger('SelectedSeasonCubit');

class SelectedSeasonCubit extends Cubit<SeasonInfo?> {
  SelectedSeasonCubit() : super(null);

  void seasonSelected(SeasonInfo info) {
    log.info('Selected season "${info.name}" with id "${info.id}"');
    emit(info);
  }
}
