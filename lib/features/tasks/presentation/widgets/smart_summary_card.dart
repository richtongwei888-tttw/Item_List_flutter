import 'package:flutter/material.dart';
import 'package:item_list_flutter/app/app_theme.dart';
import 'package:item_list_flutter/features/statistics/domain/task_statistics.dart';

class SmartSummaryCard extends StatelessWidget {
  const SmartSummaryCard({
    super.key,
    required this.statistics,
    required this.overdueCount,
    required this.dueTodayCount,
  });

  final TaskStatistics statistics;
  final int overdueCount;
  final int dueTodayCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: ClearFlowColors.sageSurface,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '智能摘要',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: ClearFlowColors.sage,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            '今天，先完成这 ${statistics.pending} 件事',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 5),
          Text(
            '$overdueCount 项已逾期，$dueTodayCount 项今天截止',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: const Color(0xFF63705E)),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _Metric(value: '${statistics.pending}', label: '待处理'),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _Metric(
                  value: '${statistics.dueWithinThreeDays}',
                  label: '三天内',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _Metric(
                  value: '${(statistics.completionRate * 100).round()}%',
                  label: '完成率',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 2),
          Text(label, style: Theme.of(context).textTheme.labelSmall),
        ],
      ),
    );
  }
}
