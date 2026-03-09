class LimitService {
  int _limit = 0;
  bool _isLimitSet = false;

  void setLimit(int limit) {
    if (limit > 0) {
      _limit = limit;
      _isLimitSet = true;
    } else {
      _limit = 0;
      _isLimitSet = false;
    }
  }

  int getLimit() => _limit;

  bool isLimitSet() => _isLimitSet;

  void clearLimit() {
    _limit = 0;
    _isLimitSet = false;
  }
}