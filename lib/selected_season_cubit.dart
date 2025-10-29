import 'package:bloc/bloc.dart';
import 'api/models/season_info.dart';

class SelectedSeasonCubit extends Cubit<SeasonInfo?> {
  SelectedSeasonCubit() : super(null);

  void seasonSelected(SeasonInfo info) => emit(info);
}
