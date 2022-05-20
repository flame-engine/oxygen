import '../components/component.dart';
import '../components/component_pool.dart';
import '../filter/filter.dart';
import 'mask.dart';

abstract class MaskDelegate {
  ComponentPool<T> getPool<T extends Component>(
    ComponentBuilder<T> componentBuilder,
  );
  FilterCheckResult checkFilter(Mask mask, [int capacity = 512]);
  void onMaskRecycle(Mask mask);
}

class FilterCheckResult {
  final Filter filter;
  final bool isNew;

  FilterCheckResult(this.filter, this.isNew);
}
