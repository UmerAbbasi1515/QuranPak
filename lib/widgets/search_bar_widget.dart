import 'package:flutter/material.dart';
import 'package:holy_quran/constant/style/app_colors.dart';
import 'package:holy_quran/constant/style/app_styles.dart';
import 'package:sizer/sizer.dart';

class SearchBarWidget extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final VoidCallback onVoice;
  final TextEditingController controller;
  final Function()? cancel;
  final bool isListening; // <-- new

  const SearchBarWidget({
    super.key,
    required this.onChanged,
    required this.onVoice,
    required this.controller,
    required this.cancel,
    this.isListening = false, // <-- new
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget>
    with SingleTickerProviderStateMixin {
  bool get _hasText => widget.controller.text.isNotEmpty;

  late final AnimationController _pulseController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  void _onTextChanged() => setState(() {});

  @override
  void didUpdateWidget(covariant SearchBarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isListening && !_pulseController.isAnimating) {
      _pulseController.repeat(reverse: true);
    } else if (!widget.isListening) {
      _pulseController.stop();
      _pulseController.value = 0;
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    _pulseController.dispose();
    super.dispose();
  }

  // clear text/search AND tell parent to cancel (stop listening etc.)
  void _handleClear() {
    widget.controller.clear();
    widget.onChanged('');
    widget.cancel?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 92.w,
      height: 5.h,
      decoration: BoxDecoration(
        gradient: AppColors.brownGradient,
        border: Border.all(
          color: widget.isListening
              ? AppColors.goldGradientBottom
              : AppColors.goldTan,
          width: widget.isListening ? 1.5 : 1,
        ),
        borderRadius: BorderRadius.circular(1.h),
      ),
      child: TextField(
        cursorColor: AppColors.white,
        controller: widget.controller,
        style: TextStyle(
          color: AppColors.white,
          fontFamily: AppFonts.interRegular,
          fontSize: 14.sp,
        ),
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          hintText: widget.isListening ? 'Listening...' : 'Search',
          hintStyle: TextStyle(
            color: AppColors.white,
            fontFamily: AppFonts.interRegular,
            fontSize: 14.sp,
          ),
          prefixIcon: const Icon(Icons.search, color: AppColors.goldTan),
          suffixIcon: IconButton(
            icon: _hasText
                ? const Icon(
                    Icons.close,
                    color: AppColors.goldTan,
                  )
                : AnimatedBuilder(
                    animation: _scaleAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: widget.isListening ? _scaleAnimation.value : 1.0,
                        child: Icon(
                          Icons.mic,
                          color: widget.isListening
                              ? AppColors.white
                              : AppColors.goldTan,
                        ),
                      );
                    },
                  ),
            onPressed: _hasText ? _handleClear : widget.onVoice,
          ),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 1, horizontal: 1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
