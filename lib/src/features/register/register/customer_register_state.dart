enum CustomerRegisterStateStatus {
  initial,
  success,
  error,
}

class CustomerRegisterState {
  final CustomerRegisterStateStatus status;
  final List<String> openingDays;
  final List<int> openingHours;

  CustomerRegisterState.initial()
      : this(
          status: CustomerRegisterStateStatus.initial,
          openingDays: <String>[],
          openingHours: <int>[],
        );

  CustomerRegisterState({
    required this.status,
    required this.openingDays,
    required this.openingHours,
  });

  CustomerRegisterState copyWith({
    CustomerRegisterStateStatus? status,
    List<String>? openingDays,
    List<int>? openingHours,
  }) {
    return CustomerRegisterState(
      status: status ?? this.status,
      openingDays: openingDays ?? this.openingDays,
      openingHours: openingHours ?? this.openingHours,
    );
  }
}
