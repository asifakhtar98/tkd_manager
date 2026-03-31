import 'package:freezed_annotation/freezed_annotation.dart';

part 'subscription_plan_entity.freezed.dart';

/// Represents a configurable subscription pricing tier.
///
/// Plans are stored in the `subscription_plans` database table and
/// drive the checkout screen's plan selection cards. Each plan defines
/// its own duration, base price, discount percentage, and computed
/// final price so that pricing is fully database-driven (no hardcoded values).
@freezed
abstract class SubscriptionPlanEntity with _$SubscriptionPlanEntity {
  const factory SubscriptionPlanEntity({
    required String id,

    /// Display name shown on plan cards (e.g., "Monthly", "Annual").
    required String name,

    /// Marketing description shown below the plan name.
    required String description,

    /// Number of subscription days this plan grants.
    required int durationDays,

    /// Pre-discount price in whole Indian Rupees.
    required int basePriceInr,

    /// Discount percentage applied to the base price (0–100).
    required int discountPercentage,

    /// Post-discount price in whole Indian Rupees.
    required int finalPriceInr,

    /// Whether this plan is currently available for purchase.
    required bool isActive,

    /// Sort order for display in the plan selection UI.
    required int displayOrder,

    /// Optional badge label shown on the plan card (e.g., "POPULAR", "BEST VALUE").
    String? badgeText,

    /// Optional feature bullet points for the plan card.
    String? featuresDescription,
  }) = _SubscriptionPlanEntity;
}
