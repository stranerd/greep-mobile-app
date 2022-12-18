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

extension RideStatusExtString on String {
  RideStatus get rideStatusValue{

    if (this == "got"){
      return RideStatus.pending;
    }
    else if (this == "start"){
      return RideStatus.inProgress;
    }

    return RideStatus.ended;
  }
}
