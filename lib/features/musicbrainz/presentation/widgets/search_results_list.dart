import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/glassmorphic_container.dart';
import '../../domain/entities/artist.dart';

class SearchResultsList extends StatelessWidget {
  final List<Artist> artists;
  final Function(Artist) onArtistTap;

  const SearchResultsList({
    super.key,
    required this.artists,
    required this.onArtistTap,
  });

  @override
  Widget build(BuildContext context) {
    if (artists.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: GlassmorphicContainer(
          borderRadius: 16,
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Text(
              'No artists found',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GlassmorphicContainer(
        borderRadius: 16,
        padding: EdgeInsets.zero,
        height: artists.length > 5 ? 320 : null,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 320),
          child: ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: artists.length,
            separatorBuilder: (context, index) => Divider(
              color: AppColors.outlineVariant.withValues(alpha: 0.2),
              height: 1,
              indent: 16,
            ),
            itemBuilder: (context, index) {
              final artist = artists[index];
              return _ArtistSearchResultItem(
                artist: artist,
                onTap: () => onArtistTap(artist),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ArtistSearchResultItem extends StatelessWidget {
  final Artist artist;
  final VoidCallback onTap;

  const _ArtistSearchResultItem({required this.artist, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          artist.name,
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.onBackground,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (artist.score != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary.withValues(
                              alpha: (artist.score! / 100).clamp(0.0, 1.0),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (artist.disambiguation != null)
                    Text(
                      artist.disambiguation!,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontSize: 11,
                        color: AppColors.onSurface.withValues(alpha: 0.7),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (artist.country != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      artist.country!,
                      style: AppTextStyles.labelSmall.copyWith(
                        fontSize: 10,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0,
                      ),
                    ),
                  ),
                if (artist.type != null)
                  Text(
                    artist.type!,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontSize: 11,
                      color: AppColors.tertiary,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
