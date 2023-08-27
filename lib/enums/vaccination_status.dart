enum VaccinationStatus {
  none(0),
  firstCompleted(1),
  allCompleted(2);

  final int status;

  const VaccinationStatus(this.status);

  static VaccinationStatus fromStatus(int status) {
    if(status == VaccinationStatus.allCompleted.status) return VaccinationStatus.allCompleted;
    if(status == VaccinationStatus.firstCompleted.status) return VaccinationStatus.firstCompleted;
    return VaccinationStatus.none;
  }
}
