## 0.2.0
- Made assertion for getting/checking/removing a `Component` stricter
- **BREAKING**: Made the `priority` field on `System` final
- **BREAKING**: Components will now be marked for removal. This fixes the concurrent modification error

## 0.1.0
- Stable null-safety release
- Added `ValueComponent` for single value components
- Refactored the Component system to allow for all types to be used as init data
- Initial setup
