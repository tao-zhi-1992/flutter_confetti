import 'package:example/code_block.g.dart';
import 'package:example/demo_stage.dart';
import 'package:example/demo_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syntax_highlight/syntax_highlight.dart';

class CodeBlock extends StatefulWidget {
  final Highlighter highlighter;
  final String buttonText;
  final VoidCallback onTap;
  final String? tip;
  final Widget? otherButton;
  final Widget? overWidget;

  /// How long the black stage stays after the effect starts.
  final Duration stageHold;

  /// When false, Play runs immediately without the black stage
  /// (e.g. in-card demos that are not full-screen overlays).
  final bool useStage;

  const CodeBlock({
    super.key,
    required this.buttonText,
    required this.onTap,
    this.otherButton,
    required this.highlighter,
    this.tip,
    this.overWidget,
    this.stageHold = const Duration(seconds: 4),
    this.useStage = true,
  });

  @override
  State<CodeBlock> createState() => _CodeBlockState();
}

class _CodeBlockState extends State<CodeBlock>
    with AutomaticKeepAliveClientMixin {
  static final Map<String, TextSpan> _spanCache = {};

  late final String _codesStr;
  late final Color _accent;
  late final TextSpan _codeSpan;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _codesStr = getCodeByTitle(widget.buttonText) as String? ?? '';
    _accent = DemoColors
        .accents[widget.buttonText.hashCode.abs() % DemoColors.accents.length];
    _codeSpan = _spanCache.putIfAbsent(
      widget.buttonText,
      () => widget.highlighter.highlight(_codesStr),
    );
  }

  void _play(BuildContext context) {
    if (!widget.useStage) {
      widget.onTap();
      return;
    }
    DemoStage.present(context, play: widget.onTap, hold: widget.stageHold);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return RepaintBoundary(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: DemoColors.surface,
          borderRadius: BorderRadius.circular(DemoRadii.lg),
          border: Border.all(color: DemoColors.line),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(DemoRadii.lg),
          clipBehavior: Clip.hardEdge,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 12, 12),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _accent,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            widget.buttonText,
                            style: DemoTextStyles.cardTitle,
                          ),
                        ),
                        IconButton(
                          tooltip: 'Copy code',
                          onPressed: () async {
                            await Clipboard.setData(
                                ClipboardData(text: _codesStr));
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Copied'),
                                  behavior: SnackBarBehavior.floating,
                                  width: 160,
                                  duration:
                                      const Duration(milliseconds: 1200),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(DemoRadii.md),
                                  ),
                                ),
                              );
                            }
                          },
                          icon: const Icon(Icons.copy_rounded, size: 18),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        FilledButton(
                          onPressed: () => _play(context),
                          style: FilledButton.styleFrom(
                            backgroundColor: DemoColors.ink,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(DemoRadii.pill),
                            ),
                            textStyle: DemoTextStyles.play,
                          ),
                          child: const Text('Play'),
                        ),
                        if (widget.otherButton != null) widget.otherButton!,
                        if (widget.tip != null)
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 320),
                            child: Text(
                              widget.tip!,
                              style: DemoTextStyles.tip,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                      decoration: BoxDecoration(
                        color: DemoColors.codeBg,
                        borderRadius: BorderRadius.circular(DemoRadii.md),
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: Stack(
                        children: [
                          // NeverScrollable: keep layout for tall snippets, but
                          // don't compete with the page scroll for wheel/trackpad.
                          SingleChildScrollView(
                            physics: const NeverScrollableScrollPhysics(),
                            padding:
                                const EdgeInsets.fromLTRB(16, 14, 16, 28),
                            child: Text.rich(
                              _codeSpan,
                              style: DemoTextStyles.code,
                            ),
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            height: 28,
                            child: IgnorePointer(
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      DemoColors.codeBg.withValues(alpha: 0),
                                      DemoColors.codeBg,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              if (widget.overWidget != null) widget.overWidget!,
            ],
          ),
        ),
      ),
    );
  }
}
