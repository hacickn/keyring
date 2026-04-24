import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

typedef OnCodeComplete = void Function(String code);

class PasscodeKeypad extends StatefulWidget {
  final OnCodeComplete onComplete;
  final VoidCallback? onBiometric;
  final bool showBiometric;
  final bool error;
  final int length;
  final Color dotFilledColor;
  final Color dotEmptyColor;
  final Color digitColor;

  const PasscodeKeypad({
    super.key,
    required this.onComplete,
    this.onBiometric,
    this.showBiometric = false,
    this.error = false,
    this.length = 6,
    this.dotFilledColor = AppColors.ink,
    this.dotEmptyColor = AppColors.line,
    this.digitColor = AppColors.ink,
  });

  @override
  State<PasscodeKeypad> createState() => PasscodeKeypadState();
}

class PasscodeKeypadState extends State<PasscodeKeypad>
    with SingleTickerProviderStateMixin {
  String _input = '';
  late AnimationController _shake;
  late Animation<double> _shakeAnim;

  @override
  void initState() {
    super.initState();
    _shake = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    _shakeAnim = CurvedAnimation(parent: _shake, curve: Curves.elasticIn);
  }

  @override
  void didUpdateWidget(covariant PasscodeKeypad old) {
    super.didUpdateWidget(old);
    if (widget.error && !old.error) {
      shakeAndClear();
    }
  }

  void shakeAndClear() {
    _shake.forward(from: 0).then((_) {
      if (mounted) setState(() => _input = '');
    });
  }

  void clear() => setState(() => _input = '');

  void _press(String digit) {
    if (_input.length >= widget.length) return;
    HapticFeedback.selectionClick();
    setState(() => _input += digit);
    if (_input.length == widget.length) {
      widget.onComplete(_input);
    }
  }

  void _backspace() {
    if (_input.isEmpty) return;
    HapticFeedback.selectionClick();
    setState(() => _input = _input.substring(0, _input.length - 1));
  }

  @override
  void dispose() {
    _shake.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _shakeAnim,
          builder: (context, child) {
            final v = _shakeAnim.value;
            final dx = (v > 0) ? (v * 10 * (1 - v) * 4) : 0.0;
            return Transform.translate(
              offset: Offset(dx, 0),
              child: child,
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.length, (i) {
              final filled = i < _input.length;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: filled
                      ? (widget.error ? AppColors.orange : widget.dotFilledColor)
                      : Colors.transparent,
                  border: Border.all(
                    color: widget.error
                        ? AppColors.orange
                        : (filled ? widget.dotFilledColor : widget.dotEmptyColor),
                    width: 1.5,
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 36),
        _buildKey('1'),
        _buildKey('4'),
        _buildKey('7'),
        _buildBottomRow(),
      ],
    );
  }

  Widget _buildKey(String firstDigit) {
    final start = int.parse(firstDigit);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _KeyButton(
            label: '${start}',
            color: widget.digitColor,
            onTap: () => _press('${start}'),
          ),
          _KeyButton(
            label: '${start + 1}',
            color: widget.digitColor,
            onTap: () => _press('${start + 1}'),
          ),
          _KeyButton(
            label: '${start + 2}',
            color: widget.digitColor,
            onTap: () => _press('${start + 2}'),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          widget.showBiometric
              ? _KeyButton(
                  icon: Icons.face_retouching_natural,
                  color: widget.digitColor,
                  onTap: widget.onBiometric ?? () {},
                )
              : const _KeyButton.empty(),
          _KeyButton(
            label: '0',
            color: widget.digitColor,
            onTap: () => _press('0'),
          ),
          _KeyButton(
            icon: Icons.backspace_outlined,
            color: widget.digitColor,
            onTap: _backspace,
          ),
        ],
      ),
    );
  }
}

class _KeyButton extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final Color color;
  final VoidCallback? onTap;
  final bool empty;

  const _KeyButton({
    this.label,
    this.icon,
    this.color = AppColors.ink,
    this.onTap,
  }) : empty = false;

  const _KeyButton.empty()
      : label = null,
        icon = null,
        color = AppColors.ink,
        onTap = null,
        empty = true;

  @override
  Widget build(BuildContext context) {
    const size = 74.0;
    if (empty) return const SizedBox(width: size + 20, height: size);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          child: icon != null
              ? Icon(icon, size: 26, color: color)
              : Text(
                  label!,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w400,
                    color: color,
                  ),
                ),
        ),
      ),
    );
  }
}
