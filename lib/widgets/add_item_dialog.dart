import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/items_provider.dart';
import '../models/item.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';

class AddItemDialog extends StatefulWidget {
  final Item? item;

  const AddItemDialog({super.key, this.item});

  @override
  State<AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _manufacturerController = TextEditingController();
  final _barcodeController = TextEditingController();
  final _weightController = TextEditingController();
  
  String _selectedCategory = AppConstants.categories.first;
  String _selectedSize = AppConstants.itemSizes.first;
  String _selectedStatus = AppConstants.itemStatuses.first;
  String _selectedBlock = AppConstants.blockNames.first;
  String _selectedRack = AppConstants.rackNames.first;
  int _selectedSlot = 1;
  
  DateTime _arrivalDate = DateTime.now();
  DateTime _expiryDate = DateTime.now().add(const Duration(days: 365));
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _populateFields();
    }
  }

  void _populateFields() {
    final item = widget.item!;
    _nameController.text = item.name;
    _manufacturerController.text = item.manufacturer;
    _barcodeController.text = item.barcode;
    _weightController.text = item.weight.toString();
    _selectedCategory = item.category;
    _selectedSize = item.size;
    _selectedStatus = item.status;
    _selectedBlock = item.locationBlock;
    _selectedRack = item.locationRack;
    _selectedSlot = item.locationSlot;
    _arrivalDate = item.arrivalDate;
    _expiryDate = item.expiryDate;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _manufacturerController.dispose();
    _barcodeController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: AppColors.backgroundGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildBasicInfoSection(),
                      const SizedBox(height: 20),
                      _buildLocationSection(),
                      const SizedBox(height: 20),
                      _buildDatesSection(),
                    ],
                  ),
                ),
              ),
            ),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.surface, width: 1),
        ),
      ),
      child: Row(
        children: [
          Icon(
            widget.item != null ? Icons.edit_rounded : Icons.add_rounded,
            color: AppColors.primary,
            size: 24,
          ),
          const SizedBox(width: 12),
          Text(
            widget.item != null ? 'Edit Item' : 'Add New Item',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.close_rounded, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Basic Information',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Item Name',
            prefixIcon: Icon(Icons.inventory_2_rounded, color: AppColors.primary),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter item name';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _manufacturerController,
          decoration: const InputDecoration(
            labelText: 'Manufacturer',
            prefixIcon: Icon(Icons.business_rounded, color: AppColors.primary),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter manufacturer';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _barcodeController,
                decoration: const InputDecoration(
                  labelText: 'Barcode',
                  prefixIcon: Icon(Icons.qr_code_rounded, color: AppColors.primary),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter barcode';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  prefixIcon: Icon(Icons.category_rounded, color: AppColors.primary),
                ),
                items: AppConstants.categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Row(
                      children: [
                        Icon(
                          AppColors.getCategoryIcon(category),
                          color: AppColors.getCategoryColor(category),
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(category),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _weightController,
                decoration: const InputDecoration(
                  labelText: 'Weight (kg)',
                  prefixIcon: Icon(Icons.scale_rounded, color: AppColors.primary),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter weight';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter valid weight';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _selectedSize,
                decoration: const InputDecoration(
                  labelText: 'Size',
                  prefixIcon: Icon(Icons.straighten_rounded, color: AppColors.primary),
                ),
                items: AppConstants.itemSizes.map((size) {
                  return DropdownMenuItem<String>(
                    value: size,
                    child: Text(size),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSize = value!;
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Location',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _selectedBlock,
                decoration: const InputDecoration(
                  labelText: 'Block',
                  prefixIcon: Icon(Icons.warehouse_rounded, color: AppColors.primary),
                ),
                items: AppConstants.blockNames.map((block) {
                  return DropdownMenuItem<String>(
                    value: block,
                    child: Text('Block $block'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedBlock = value!;
                  });
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _selectedRack,
                decoration: const InputDecoration(
                  labelText: 'Rack',
                  prefixIcon: Icon(Icons.view_module_rounded, color: AppColors.primary),
                ),
                items: AppConstants.rackNames.map((rack) {
                  return DropdownMenuItem<String>(
                    value: rack,
                    child: Text('Rack $rack'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedRack = value!;
                  });
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DropdownButtonFormField<int>(
                value: _selectedSlot,
                decoration: const InputDecoration(
                  labelText: 'Slot',
                  prefixIcon: Icon(Icons.grid_view_rounded, color: AppColors.primary),
                ),
                items: List.generate(AppConstants.slotsPerRack, (index) {
                  return DropdownMenuItem<int>(
                    value: index + 1,
                    child: Text('Slot ${index + 1}'),
                  );
                }),
                onChanged: (value) {
                  setState(() {
                    _selectedSlot = value!;
                  });
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: _selectedStatus,
          decoration: const InputDecoration(
            labelText: 'Status',
            prefixIcon: Icon(Icons.info_rounded, color: AppColors.primary),
          ),
          items: AppConstants.itemStatuses.map((status) {
            return DropdownMenuItem<String>(
              value: status,
              child: Text(status.replaceAll('_', ' ').toUpperCase()),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedStatus = value!;
            });
          },
        ),
      ],
    );
  }

  Widget _buildDatesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Dates',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ListTile(
                leading: const Icon(Icons.calendar_today_rounded, color: AppColors.primary),
                title: const Text('Arrival Date'),
                subtitle: Text(
                  '${_arrivalDate.day}/${_arrivalDate.month}/${_arrivalDate.year}',
                  style: const TextStyle(color: Colors.white),
                ),
                onTap: _selectArrivalDate,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ListTile(
                leading: const Icon(Icons.event_rounded, color: AppColors.primary),
                title: const Text('Expiry Date'),
                subtitle: Text(
                  '${_expiryDate.day}/${_expiryDate.month}/${_expiryDate.year}',
                  style: const TextStyle(color: Colors.white),
                ),
                onTap: _selectExpiryDate,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.surface, width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: _isLoading ? null : _saveItem,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(widget.item != null ? 'Update' : 'Add'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectArrivalDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _arrivalDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() {
        _arrivalDate = date;
      });
    }
  }

  Future<void> _selectExpiryDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _expiryDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (date != null) {
      setState(() {
        _expiryDate = date;
      });
    }
  }

  Future<void> _saveItem() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final item = Item(
        id: widget.item?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        manufacturer: _manufacturerController.text.trim(),
        barcode: _barcodeController.text.trim(),
        size: _selectedSize,
        weight: double.parse(_weightController.text),
        arrivalDate: _arrivalDate,
        expiryDate: _expiryDate,
        locationBlock: _selectedBlock,
        locationRack: _selectedRack,
        locationSlot: _selectedSlot,
        status: _selectedStatus,
        category: _selectedCategory,
      );

      final itemsProvider = Provider.of<ItemsProvider>(context, listen: false);
      bool success;

      if (widget.item != null) {
        success = await itemsProvider.updateItem(widget.item!.id, item);
      } else {
        success = await itemsProvider.addItem(item);
      }

      if (success && mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.item != null 
                  ? 'Item updated successfully' 
                  : 'Item added successfully',
            ),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
