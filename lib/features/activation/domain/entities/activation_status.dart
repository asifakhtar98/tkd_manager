/// Represents the activation status of the current user's software subscription.
///
/// This sealed class drives the dashboard activation banner and determines
/// what call-to-action is shown to the user.
sealed class ActivationStatus {
  const ActivationStatus();
}

/// The user has an active subscription that expires at [expiresAt].
class ActivationStatusActive extends ActivationStatus {
  const ActivationStatusActive({required this.expiresAt});

  final DateTime expiresAt;
}

/// The user has submitted an activation request that is awaiting admin review.
class ActivationStatusPendingReview extends ActivationStatus {
  const ActivationStatusPendingReview();
}

/// The user has no active subscription and no pending requests.
class ActivationStatusNotActivated extends ActivationStatus {
  const ActivationStatusNotActivated();
}
