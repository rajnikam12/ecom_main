import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/product/product_bloc.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({super.key});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
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
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    // Responsive sizing
    final fontSize = isTablet ? 18.0 : 16.0;
    final iconSize = isTablet ? 28.0 : 24.0;
    final borderRadius = isTablet ? 16.0 : 12.0;
    final contentPadding = EdgeInsets.symmetric(
      vertical: isTablet ? 16 : 14,
      horizontal: isTablet ? 20 : 16,
    );

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.onSurface.withOpacity(0.1),
            blurRadius: isTablet ? 12 : 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        style: TextStyle(
          fontSize: fontSize,
          color: theme.colorScheme.onSurface,
        ),
        decoration: InputDecoration(
          hintText: 'Search products...',
          hintStyle: TextStyle(
            color: theme.colorScheme.onSurface.withOpacity(0.5),
            fontSize: fontSize,
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.all(isTablet ? 12 : 10),
            child: Icon(
              Icons.search,
              color: theme.colorScheme.onSurface.withOpacity(0.6),
              size: iconSize,
            ),
          ),
          suffixIcon: _controller.text.isNotEmpty
              ? Padding(
                  padding: EdgeInsets.all(isTablet ? 8 : 6),
                  child: IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                      size: iconSize * 0.8,
                    ),
                    onPressed: () {
                      _controller.clear();
                      context
                          .read<ProductBloc>()
                          .add(const SearchProductsEvent(''));
                      setState(() {});
                    },
                  ),
                )
              : null,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              color: theme.colorScheme.outline.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              color: theme.colorScheme.primary,
              width: 2.0,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              color: theme.colorScheme.error,
              width: 1.5,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              color: theme.colorScheme.error,
              width: 2.0,
            ),
          ),
          contentPadding: contentPadding,
          filled: true,
          fillColor: theme.colorScheme.surface,
        ),
        onChanged: (value) {
          // Trigger search event on text change
          context.read<ProductBloc>().add(SearchProductsEvent(value));
          setState(() {}); // Update suffix icon visibility
        },
        onSubmitted: (value) {
          _focusNode.unfocus();
        },
        textInputAction: TextInputAction.search,
      ),
    );
  }
}
