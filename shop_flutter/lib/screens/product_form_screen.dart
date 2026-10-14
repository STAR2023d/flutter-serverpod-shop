import 'package:flutter/material.dart';
import 'package:serverpod_client/serverpod_client.dart';
import 'package:shop_client/shop_client.dart';

import '../client.dart';

/// Add a new product, or edit an existing one when [product] is given.
class ProductFormScreen extends StatefulWidget {
  const ProductFormScreen({super.key, this.product});

  final Product? product;

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _description;
  late final TextEditingController _price;
  late final TextEditingController _stock;
  late final TextEditingController _image;
  late final TextEditingController _details;

  bool _saving = false;
  String? _error;

  bool get _editing => widget.product != null;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _name = TextEditingController(text: p?.name ?? '');
    _description = TextEditingController(text: p?.description ?? '');
    _price = TextEditingController(
      text: p == null
          ? ''
          : p.price.toStringAsFixed(p.price == p.price.roundToDouble() ? 0 : 2),
    );
    _stock = TextEditingController(text: p == null ? '' : '${p.stock}');
    _image = TextEditingController(text: p?.imageUrl ?? '');
    _details = TextEditingController(
      text:
          p?.metadata?.entries.map((e) => '${e.key}: ${e.value}').join('\n') ??
          '',
    );
  }

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    _price.dispose();
    _stock.dispose();
    _image.dispose();
    _details.dispose();
    super.dispose();
  }

  InputDecoration _decoration(String label, {String? hint, String? helper}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      helperText: helper,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  /// "Color: Black" lines become {"Color": "Black"}.
  Map<String, String>? _parseDetails() {
    final result = <String, String>{};
    for (final line in _details.text.split('\n')) {
      final index = line.indexOf(':');
      if (index <= 0) continue;
      final key = line.substring(0, index).trim();
      final value = line.substring(index + 1).trim();
      if (key.isNotEmpty && value.isNotEmpty) result[key] = value;
    }
    return result.isEmpty ? null : result;
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final image = _image.text.trim();
    final product = Product(
      id: widget.product?.id,
      name: _name.text.trim(),
      description: _description.text.trim(),
      price: double.parse(_price.text.trim().replaceAll(',', '')),
      stock: int.parse(_stock.text.trim()),
      imageUrl: image.isEmpty ? null : image,
      metadata: _parseDetails(),
    );

    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await client.admin.saveProduct(product);
      if (mounted) Navigator.of(context).pop(true);
    } on ShopException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } on ServerpodClientException catch (e) {
      if (mounted) setState(() => _error = 'Server error: ${e.message}');
    } catch (_) {
      if (mounted) setState(() => _error = 'Something went wrong. Try again.');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete this product?'),
        content: Text(
          '"${widget.product!.name}" will be removed from the shop.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Keep it'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await client.admin.deleteProduct(widget.product!.id!);
      if (mounted) Navigator.of(context).pop(true);
    } on ShopException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } catch (_) {
      if (mounted) setState(() => _error = 'Something went wrong. Try again.');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(_editing ? 'Edit product' : 'Add product')),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                TextFormField(
                  controller: _name,
                  textCapitalization: TextCapitalization.words,
                  decoration: _decoration('Product name'),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Give the product a name'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _description,
                  minLines: 3,
                  maxLines: 6,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: _decoration('Description'),
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _price,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: _decoration('Price (KES)'),
                        validator: (v) {
                          final value = double.tryParse(
                            (v ?? '').replaceAll(',', ''),
                          );
                          return (value == null || value <= 0)
                              ? 'Enter a price above 0'
                              : null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _stock,
                        keyboardType: TextInputType.number,
                        decoration: _decoration('In stock'),
                        validator: (v) {
                          final value = int.tryParse((v ?? '').trim());
                          return (value == null || value < 0)
                              ? 'Enter 0 or more'
                              : null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _image,
                  keyboardType: TextInputType.url,
                  decoration: _decoration(
                    'Image link (optional)',
                    hint: 'https://...',
                    helper: 'A direct link to a photo of the product',
                  ),
                  validator: (v) {
                    final value = (v ?? '').trim();
                    if (value.isEmpty) return null;
                    return (value.startsWith('http://') ||
                            value.startsWith('https://'))
                        ? null
                        : 'The link must start with http:// or https://';
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _details,
                  minLines: 2,
                  maxLines: 5,
                  decoration: _decoration(
                    'Extra details (optional)',
                    hint: 'Color: Black\nSize: 42',
                    helper: 'One per line, written as Name: Value',
                  ),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _error!,
                      style: TextStyle(
                        color: theme.colorScheme.onErrorContainer,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _saving ? null : _save,
                  child: _saving
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(_editing ? 'Save changes' : 'Add product'),
                ),
                if (_editing) ...[
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: _saving ? null : _delete,
                    style: TextButton.styleFrom(
                      foregroundColor: theme.colorScheme.error,
                    ),
                    child: const Text('Delete product'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
