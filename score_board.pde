class score_board{
  int last_combo;
  int count_combo;
  int best_combo;
  void clear_combo(){
    if (count_combo>0)last_combo=count_combo;
    count_combo=0;
  }
  void add_combo(){
    count_combo++;
    if (count_combo>best_combo) best_combo=count_combo;
  }
}
