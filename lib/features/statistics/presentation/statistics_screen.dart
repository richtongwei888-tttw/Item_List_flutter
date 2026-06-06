import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:item_list_flutter/app/app_theme.dart';
import 'package:item_list_flutter/features/statistics/domain/task_statistics.dart';
import 'package:item_list_flutter/features/tasks/presentation/task_providers.dart';

class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statisticsValue = ref.watch(taskStatisticsProvider);
    return statisticsValue.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => const Center(child: Text('未能读取统计数据')),
      data: (statistics) => SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 110),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '本地任务概览',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: const Color(0xFF7C8174)),
            ),
            const SizedBox(height: 4),
            Text('完成得怎么样', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 22),
            _CompletionPanel(statistics: statistics),
            const SizedBox(height: 14),
            GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.55,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _MetricCard(value: statistics.pending, label: '待处理'),
                _MetricCard(value: statistics.completed, label: '已完成'),
                _MetricCard(value: statistics.total, label: '全部任务'),
                _MetricCard(
                  value: statistics.dueWithinThreeDays,
                  label: '近三天到期',
                ),
              ],
            ),
            const SizedBox(height: 14),
            _NearTermCard(statistics: statistics),
          ],
        ),
      ),
    );
  }
}

class _CompletionPanel extends StatelessWidget {
  const _CompletionPanel({required this.statistics});

  final TaskStatistics statistics;

  @override
  Widget build(BuildContext context) {
    final percent = (statistics.completionRate * 100).round();
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ClearFlowColors.sageSurface,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 104,
            height: 104,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Semantics(
                  label: '总体完成率 $percent%',
                  child: ExcludeSemantics(
                    child: SizedBox.expand(
                      child: CircularProgressIndicator(
                        value: statistics.completionRate,
                        strokeWidth: 10,
                        strokeCap: StrokeCap.round,
                        backgroundColor: Colors.white.withValues(alpha: 0.72),
                        color: ClearFlowColors.sage,
                      ),
                    ),
                  ),
                ),
                Text(
                  '$percent%',
                  style: Theme.of(
                    context,
                  ).textTheme.headlineMedium?.copyWith(fontSize: 26),
                ),
              ],
            ),
          ),
          const SizedBox(width: 22),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '总体完成率',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  statistics.total == 0
                      ? '从第一个任务开始建立节奏'
                      : '已完成 ${statistics.completed} / ${statistics.total} 项',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF63705E),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.value, required this.label});

  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$value',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontSize: 28),
            ),
            const SizedBox(height: 4),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _NearTermCard extends StatelessWidget {
  const _NearTermCard({required this.statistics});

  final TaskStatistics statistics;

  @override
  Widget build(BuildContext context) {
    final count = statistics.dueWithinThreeDays;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0EB),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '接下来三天',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: const Color(0xFFB64C36),
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            count == 0 ? '近期没有到期任务' : '$count 项任务即将到期',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 13),
          LinearProgressIndicator(
            value: statistics.total == 0
                ? 0
                : count / statistics.total.clamp(1, statistics.total),
            minHeight: 7,
            borderRadius: BorderRadius.circular(99),
            backgroundColor: Colors.white.withValues(alpha: 0.7),
            color: ClearFlowColors.coral,
            semanticsLabel: '近三天到期任务占比',
          ),
        ],
      ),
    );
  }
}
