enum RideStatus {pending, inProgress, ended}

extension RideStatusExt on RideStatus {
  String get value {
    switch(this){

      case RideStatus.pending:
        return "got";
      case RideStatus.inProgress:
        return "start";
        break;
      case RideStatus.ended:
        return "end";
    }
  }
}
