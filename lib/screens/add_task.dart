import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/task.dart';

class _CanvaColors {
  static const teal        = Color(0xFF00C4CC); 
  static const tealDark    = Color(0xFF00A8AF);   
  static const tealLight   = Color(0xFFE0F9FA);   
  static const navy        = Color(0xFF1A1A2E);   
  static const surface     = Color(0xFFFFFFFF);   
  static const cardBg      = Color(0xFFF7FAFA);   
  static const labelText   = Color(0xFF2D3436);  
  static const hintText    = Color(0xFF8E9BAF);  
  static const border      = Color(0xFFDDE3E8);  
  static const iconColor   = Color(0xFF00C4CC);  
}

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController taskController        = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String?  selectedCategory;
  String?  selectedPriority;
  DateTime? selectedDate;
  bool isImportant     = false;
  bool reminderEnabled = false;

  @override
  void dispose() {
    taskController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

 
  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: _CanvaColors.hintText, fontSize: 14),
      prefixIcon: Icon(icon, color: _CanvaColors.iconColor, size: 20),
      filled: true,
      fillColor: _CanvaColors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _CanvaColors.border, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _CanvaColors.teal, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
      ),
    );
  }

  // ── section label ──────────────────────────────────────────────────────────
  Widget _sectionLabel(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.6,
            color: _CanvaColors.labelText,
          ),
        ),
      );

  Widget _card({required Widget child}) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _CanvaColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _CanvaColors.border, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: child,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),

     
      appBar: AppBar(
        backgroundColor: _CanvaColors.teal,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          "New Task",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 40),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              
              _card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionLabel("TASK NAME"),
                    TextFormField(
                      controller: taskController,
                      style: const TextStyle(
                        fontSize: 15,
                        color: _CanvaColors.labelText,
                      ),
                      decoration: _inputDecoration(
                        hint: "What do you need to do?",
                        icon: Icons.edit_note_rounded,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter a task name";
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              
              _card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionLabel("DESCRIPTION"),
                    TextFormField(
                      controller: descriptionController,
                      maxLines: 4,
                      style: const TextStyle(
                        fontSize: 15,
                        color: _CanvaColors.labelText,
                      ),
                      decoration: InputDecoration(
                        hintText: "Add more details about your task…",
                        hintStyle: const TextStyle(
                          color: _CanvaColors.hintText,
                          fontSize: 14,
                        ),
                        filled: true,
                        fillColor: _CanvaColors.surface,
                        contentPadding: const EdgeInsets.all(16),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: _CanvaColors.border,
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: _CanvaColors.teal,
                            width: 2,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Colors.redAccent,
                            width: 1.5,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Colors.redAccent,
                            width: 2,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter a description";
                        }
                        if (value.trim().length < 10) {
                          return "Description must be at least 10 characters";
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              
              Row(
                children: [
                  // Category
                  Expanded(
                    child: _card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionLabel("CATEGORY"),
                          DropdownButtonFormField<String>(
                            value: selectedCategory,
                            icon: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: _CanvaColors.teal,
                            ),
                            dropdownColor: _CanvaColors.surface,
                            style: const TextStyle(
                              fontSize: 14,
                              color: _CanvaColors.labelText,
                            ),
                            decoration: _inputDecoration(
                              hint: "Category",
                              icon: Icons.category_rounded,
                            ),
                            hint: const Text(
                              "Select",
                              style: TextStyle(
                                color: _CanvaColors.hintText,
                                fontSize: 14,
                              ),
                            ),
                            items: const [
                              DropdownMenuItem(value: "Coding",   child: Text("Coding")),
                              DropdownMenuItem(value: "Study",    child: Text("Study")),
                              DropdownMenuItem(value: "Projects", child: Text("Projects")),
                              DropdownMenuItem(value: "Personal", child: Text("Personal")),
                            ],
                            onChanged: (value) =>
                                setState(() => selectedCategory = value),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Priority
                  Expanded(
                    child: _card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionLabel("PRIORITY"),
                          DropdownButtonFormField<String>(
                            value: selectedPriority,
                            icon: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: _CanvaColors.teal,
                            ),
                            dropdownColor: _CanvaColors.surface,
                            style: const TextStyle(
                              fontSize: 14,
                              color: _CanvaColors.labelText,
                            ),
                            decoration: _inputDecoration(
                              hint: "Priority",
                              icon: Icons.flag_rounded,
                            ),
                            hint: const Text(
                              "Select",
                              style: TextStyle(
                                color: _CanvaColors.hintText,
                                fontSize: 14,
                              ),
                            ),
                            items: const [
                              DropdownMenuItem(value: "Low",    child: Text("Low")),
                              DropdownMenuItem(value: "Medium", child: Text("Medium")),
                              DropdownMenuItem(value: "High",   child: Text("High")),
                            ],
                            onChanged: (value) =>
                                setState(() => selectedPriority = value),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              
              _card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionLabel("DUE DATE"),
                    InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2030),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme.light(
                                  primary: _CanvaColors.teal,
                                  onPrimary: Colors.white,
                                  surface: _CanvaColors.surface,
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (date != null) setState(() => selectedDate = date);
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: _CanvaColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: selectedDate != null
                                ? _CanvaColors.teal
                                : _CanvaColors.border,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_month_rounded,
                              color: _CanvaColors.teal,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              selectedDate == null
                                  ? "Pick a due date"
                                  : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                              style: TextStyle(
                                fontSize: 14,
                                color: selectedDate == null
                                    ? _CanvaColors.hintText
                                    : _CanvaColors.labelText,
                              ),
                            ),
                            const Spacer(),
                            if (selectedDate != null)
                              const Icon(
                                Icons.check_circle_rounded,
                                color: _CanvaColors.teal,
                                size: 18,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              
              _card(
                child: Column(
                  children: [
                    // Mark as Important
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: _CanvaColors.tealLight,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.star_rounded,
                            color: _CanvaColors.teal,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            "Mark as Important",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: _CanvaColors.labelText,
                            ),
                          ),
                        ),
                        Switch(
                          value: isImportant,
                          activeColor: _CanvaColors.teal,
                          onChanged: (v) => setState(() => isImportant = v),
                        ),
                      ],
                    ),

                    const Divider(color: _CanvaColors.border, height: 24),

                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: _CanvaColors.tealLight,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.notifications_active_rounded,
                            color: _CanvaColors.teal,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            "Enable Reminder",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: _CanvaColors.labelText,
                            ),
                          ),
                        ),
                        Switch(
                          value: reminderEnabled,
                          activeColor: _CanvaColors.teal,
                          onChanged: (v) => setState(() => reminderEnabled = v),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final task = Task(
                        name: taskController.text.trim(),
                        description: descriptionController.text.trim(),
                        category: selectedCategory,
                        priority: selectedPriority,
                        dueDate: selectedDate,
                        isImportant: isImportant,
                        reminderEnabled: reminderEnabled,
                        completed: false,
                      );
                      context.pop(task);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _CanvaColors.teal,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    shadowColor: _CanvaColors.teal.withOpacity(0.4),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_task_rounded, size: 20),
                      SizedBox(width: 8),
                      Text(
                        "Create Task",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}