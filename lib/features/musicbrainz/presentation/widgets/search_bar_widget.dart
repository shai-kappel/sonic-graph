import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/glassmorphic_container.dart';
import '../bloc/musicbrainz_bloc.dart';
import '../bloc/musicbrainz_event.dart';
import '../bloc/musicbrainz_state.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({super.key});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MusicBrainzBloc, MusicBrainzState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GlassmorphicContainer(
            height: 48,
            borderRadius: 24,
            padding: EdgeInsets.zero,
            useBorder: true,
            borderColor: AppColors.primary.withValues(
              alpha: AppColors.ghostBorderOpacity,
            ),
            child: Row(
              children: [
                const SizedBox(width: 12),
                Icon(
                  Icons.search,
                  size: 20,
                  color: AppColors.primary.withValues(alpha: 0.6),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.onBackground,
                    ),
                    cursorColor: AppColors.primary,
                    decoration: InputDecoration(
                      hintText: 'Search artists...',
                      hintStyle: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.onBackground.withValues(alpha: 0.4),
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onChanged: (value) {
                      context.read<MusicBrainzBloc>().add(
                        SearchArtistsEvent(value),
                      );
                    },
                  ),
                ),
                if (_controller.text.isNotEmpty || state is MusicBrainzLoading)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: state is MusicBrainzLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                              strokeWidth: 2,
                            ),
                          )
                        : IconButton(
                            icon: const Icon(Icons.close, size: 20),
                            color: AppColors.onSurface.withValues(alpha: 0.5),
                            onPressed: () {
                              _controller.clear();
                              context.read<MusicBrainzBloc>().add(
                                ClearSearchEvent(),
                              );
                            },
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                  ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        );
      },
    );
  }
}
