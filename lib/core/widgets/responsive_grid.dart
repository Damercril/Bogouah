import 'package:flutter/material.dart';
import '../utils/responsive_helper.dart';

/// Widget de grille responsive qui s'adapte à la taille de l'écran
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final double runSpacing;
  final int? mobileColumns;
  final int? tabletColumns;
  final int? desktopColumns;
  final double? childAspectRatio;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.spacing = 16,
    this.runSpacing = 16,
    this.mobileColumns,
    this.tabletColumns,
    this.desktopColumns,
    this.childAspectRatio,
  });

  @override
  Widget build(BuildContext context) {
    final columns = ResponsiveHelper.value(
      context: context,
      mobile: mobileColumns ?? 1,
      tablet: tabletColumns ?? 2,
      desktop: desktopColumns ?? 3,
    );

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: spacing,
        mainAxisSpacing: runSpacing,
        childAspectRatio: childAspectRatio ?? 1.0,
      ),
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }
}

/// Widget de liste responsive qui affiche en grille sur web et en liste sur mobile
class ResponsiveListGrid extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final EdgeInsets? padding;

  const ResponsiveListGrid({
    super.key,
    required this.children,
    this.spacing = 16,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    if (ResponsiveHelper.isMobile(context)) {
      // Sur mobile, afficher en liste
      return ListView.separated(
        padding: padding ?? EdgeInsets.all(spacing),
        itemCount: children.length,
        separatorBuilder: (context, index) => SizedBox(height: spacing),
        itemBuilder: (context, index) => children[index],
      );
    } else {
      // Sur web, afficher en grille
      final columns = ResponsiveHelper.isDesktop(context) ? 3 : 2;
      return GridView.builder(
        padding: padding ?? EdgeInsets.all(spacing),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          crossAxisSpacing: spacing,
          mainAxisSpacing: spacing,
          childAspectRatio: 1.2,
        ),
        itemCount: children.length,
        itemBuilder: (context, index) => children[index],
      );
    }
  }
}

/// Widget de carte responsive avec padding adapté
class ResponsiveCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final Color? color;
  final double? elevation;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;

  const ResponsiveCard({
    super.key,
    required this.child,
    this.padding,
    this.color,
    this.elevation,
    this.borderRadius,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardPadding = padding ??
        EdgeInsets.all(
          ResponsiveHelper.value(
            context: context,
            mobile: 16,
            tablet: 20,
            desktop: 24,
          ),
        );

    final card = Card(
      elevation: elevation ?? 2,
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(16),
      ),
      child: Padding(
        padding: cardPadding,
        child: child,
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        child: card,
      );
    }

    return card;
  }
}

/// Container avec largeur maximale responsive
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final Color? color;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.padding,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: color,
      padding: padding ??
          EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.getHorizontalPadding(context),
            vertical: 16,
          ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: ResponsiveHelper.getMaxContentWidth(context),
          ),
          child: child,
        ),
      ),
    );
  }
}

/// Widget de deux colonnes responsive (devient une colonne sur mobile)
class ResponsiveTwoColumns extends StatelessWidget {
  final Widget left;
  final Widget right;
  final double spacing;
  final double? leftFlex;
  final double? rightFlex;

  const ResponsiveTwoColumns({
    super.key,
    required this.left,
    required this.right,
    this.spacing = 16,
    this.leftFlex,
    this.rightFlex,
  });

  @override
  Widget build(BuildContext context) {
    if (ResponsiveHelper.isMobile(context)) {
      return Column(
        children: [
          left,
          SizedBox(height: spacing),
          right,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: (leftFlex ?? 1).toInt(),
          child: left,
        ),
        SizedBox(width: spacing),
        Expanded(
          flex: (rightFlex ?? 1).toInt(),
          child: right,
        ),
      ],
    );
  }
}
