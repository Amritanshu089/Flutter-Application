import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';

// ─── Canva palette (shared across screens) ───────────────────────────────────
class _C {
  static const teal      = Color(0xFF00C4CC);
  static const tealDark  = Color(0xFF00A8AF);
  static const tealLight = Color(0xFFE0F9FA);
  static const bg        = Color(0xFFF0F4F8);
  static const surface   = Color(0xFFFFFFFF);
  static const label     = Color(0xFF2D3436);
  static const sub       = Color(0xFF636E72);
  static const border    = Color(0xFFDDE3E8);
}

// ─── Category meta ────────────────────────────────────────────────────────────
class _Cat {
  final String label;
  final IconData icon;
  final Color color;
  final Color bg;
  const _Cat(this.label, this.icon, this.color, this.bg);
}

const _categories = [
  _Cat("Coding",   Icons.code_rounded,        Color(0xFF0984E3), Color(0xFFEBF5FF)),
  _Cat("Study",    Icons.menu_book_rounded,    Color(0xFFE17055), Color(0xFFFFF3EE)),
  _Cat("Projects", Icons.rocket_launch_rounded,Color(0xFF00B894), Color(0xFFE6FAF5)),
  _Cat("Personal", Icons.person_rounded,       Color(0xFF6C5CE7), Color(0xFFF0EEFF)),
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskProvider>().loadTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();
    final tasks        = taskProvider.tasks;
    final done         = tasks.where((t) => t.completed).length;

    return Scaffold(
      backgroundColor: _C.bg,

      // ── AppBar / Header ─────────────────────────────────────────────────────
      appBar: AppBar(
        backgroundColor: _C.teal,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
        toolbarHeight: 80,
        flexibleSpace: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo chip
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.task_alt_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Task Manager",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 0.3,
                        ),
                      ),
                      Text(
                        tasks.isEmpty
                            ? "No tasks yet"
                            : "$done / ${tasks.length} completed",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.85),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                // Progress ring
                if (tasks.isNotEmpty)
                  SizedBox(
                    width: 44,
                    height: 44,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CircularProgressIndicator(
                          value: done / tasks.length,
                          backgroundColor: Colors.white.withOpacity(0.25),
                          valueColor: const AlwaysStoppedAnimation(Colors.white),
                          strokeWidth: 4,
                        ),
                        Center(
                          child: Text(
                            "${((done / tasks.length) * 100).round()}%",
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),

      // ── Body ────────────────────────────────────────────────────────────────
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Categories ────────────────────────────────────────────────────
            const Text(
              "Categories",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: _C.label,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 12),

            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.8,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: _categories.map(_buildCategoryCard).toList(),
            ),

            const SizedBox(height: 24),

            // ── My Tasks header ───────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "My Tasks",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: _C.label,
                    letterSpacing: 0.2,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _C.tealLight,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "${tasks.length} Task${tasks.length == 1 ? '' : 's'}",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _C.tealDark,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // ── Task List ─────────────────────────────────────────────────────
            Expanded(
              child: taskProvider.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: _C.teal),
                    )
                  : taskProvider.errorMessage != null
                      ? _buildError(taskProvider)
                      : tasks.isEmpty
                          ? _buildEmpty()
                          : ListView.separated(
                              itemCount: tasks.length,
                              padding: const EdgeInsets.only(bottom: 100),
                              separatorBuilder: (_, _unused) =>
                                  const SizedBox(height: 10),
                              itemBuilder: (context, index) {
                                final task = tasks[index];
                                return _TaskCard(
                                  task: task,
                                  onComplete: () =>
                                      taskProvider.completeTask(task),
                                  onEdit: () =>
                                      _editTask(context, task),
                                  onDelete: () =>
                                      _deleteTask(context, task),
                                );
                              },
                            ),
            ),
          ],
        ),
      ),

      // ── FAB ─────────────────────────────────────────────────────────────────
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final newTask = await context.push<Task>('/add-task');
          if (newTask != null && context.mounted) {
            await context.read<TaskProvider>().addTask(newTask);
          }
        },
        backgroundColor: _C.teal,
        foregroundColor: Colors.white,
        elevation: 4,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          "New Task",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  // ── Category card ──────────────────────────────────────────────────────────
  Widget _buildCategoryCard(_Cat cat) {
    return Container(
      decoration: BoxDecoration(
        color: cat.bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cat.color.withValues(alpha: 0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: cat.color.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 14),
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: cat.color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(cat.icon, size: 18, color: cat.color),
          ),
          const SizedBox(width: 10),
          Text(
            cat.label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: cat.color,
            ),
          ),
        ],
      ),
    );
  }

  // ── Empty state ────────────────────────────────────────────────────────────
  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: _C.tealLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.inbox_rounded,
              size: 48,
              color: _C.teal,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "No tasks yet!",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: _C.label,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            "Tap the button below to add your first task",
            style: TextStyle(fontSize: 13, color: _C.sub),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ── Error state ────────────────────────────────────────────────────────────
  Widget _buildError(TaskProvider taskProvider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline_rounded,
              size: 50, color: Colors.redAccent),
          const SizedBox(height: 10),
          const Text(
            "Something went wrong",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _C.label),
          ),
          const SizedBox(height: 6),
          Text(
            taskProvider.errorMessage!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: _C.sub),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: taskProvider.loadTasks,
            style: ElevatedButton.styleFrom(
              backgroundColor: _C.teal,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: const Text("Retry"),
          ),
        ],
      ),
    );
  }

  // ── Delete dialog ──────────────────────────────────────────────────────────
  void _deleteTask(BuildContext context, Task task) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          "Delete Task",
          style: TextStyle(fontWeight: FontWeight.w700, color: _C.label),
        ),
        content: const Text(
          "Are you sure you want to delete this task?",
          style: TextStyle(color: _C.sub),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Cancel",
                style: TextStyle(color: _C.sub)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await context.read<TaskProvider>().deleteTask(task);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  // ── Edit dialog ────────────────────────────────────────────────────────────
  void _editTask(BuildContext context, Task task) {
    final nameCtrl = TextEditingController(text: task.name);
    final descCtrl = TextEditingController(text: task.description);
    String? category = task.category;
    String? priority = task.priority;
    bool important   = task.isImportant;
    bool reminder    = task.reminderEnabled;

    InputDecoration fieldDeco(String label, IconData icon) =>
        InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: _C.sub, fontSize: 13),
          prefixIcon: Icon(icon, color: _C.teal, size: 18),
          filled: true,
          fillColor: _C.surface,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: _C.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: _C.teal, width: 2),
          ),
        );

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: _C.bg,
          titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          contentPadding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: _C.tealLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.edit_rounded,
                    color: _C.teal, size: 18),
              ),
              const SizedBox(width: 10),
              const Text(
                "Edit Task",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: _C.label),
              ),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 8),
                  TextField(
                    controller: nameCtrl,
                    decoration: fieldDeco(
                        "Task Name", Icons.edit_note_rounded),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: descCtrl,
                    maxLines: 3,
                    decoration: fieldDeco(
                        "Description", Icons.notes_rounded),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: category,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded,
                        color: _C.teal),
                    dropdownColor: _C.surface,
                    decoration:
                        fieldDeco("Category", Icons.category_rounded),
                    items: const [
                      DropdownMenuItem(
                          value: "Coding", child: Text("Coding")),
                      DropdownMenuItem(
                          value: "Study", child: Text("Study")),
                      DropdownMenuItem(
                          value: "Projects", child: Text("Projects")),
                      DropdownMenuItem(
                          value: "Personal", child: Text("Personal")),
                    ],
                    onChanged: (v) =>
                        setDialogState(() => category = v),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: priority,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded,
                        color: _C.teal),
                    dropdownColor: _C.surface,
                    decoration:
                        fieldDeco("Priority", Icons.flag_rounded),
                    items: const [
                      DropdownMenuItem(
                          value: "Low", child: Text("Low")),
                      DropdownMenuItem(
                          value: "Medium", child: Text("Medium")),
                      DropdownMenuItem(
                          value: "High", child: Text("High")),
                    ],
                    onChanged: (v) =>
                        setDialogState(() => priority = v),
                  ),
                  const SizedBox(height: 4),
                  // Important toggle
                  _toggleRow(
                    icon: Icons.star_rounded,
                    label: "Mark as Important",
                    value: important,
                    onChanged: (v) =>
                        setDialogState(() => important = v),
                  ),
                  _toggleRow(
                    icon: Icons.notifications_active_rounded,
                    label: "Enable Reminder",
                    value: reminder,
                    onChanged: (v) =>
                        setDialogState(() => reminder = v),
                  ),
                ],
              ),
            ),
          ),
          actionsPadding:
              const EdgeInsets.fromLTRB(20, 8, 20, 16),
          actions: [
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _C.sub,
                      side: const BorderSide(color: _C.border),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding:
                          const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text("Cancel"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final name = nameCtrl.text.trim();
                      if (name.isEmpty) return;
                      task.name            = name;
                      task.description     = descCtrl.text.trim();
                      task.category        = category;
                      task.priority        = priority;
                      task.isImportant     = important;
                      task.reminderEnabled = reminder;
                      await context
                          .read<TaskProvider>()
                          .updateTask(task);
                      if (context.mounted) {
                        Navigator.pop(dialogContext);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _C.teal,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding:
                          const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      "Save Changes",
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _toggleRow({
    required IconData icon,
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: _C.teal, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(label,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _C.label)),
          ),
          Switch(
            value: value,
            activeThumbColor: _C.teal,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

// ─── Polished Task Card ───────────────────────────────────────────────────────
class _TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onComplete;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _TaskCard({
    required this.task,
    required this.onComplete,
    required this.onEdit,
    required this.onDelete,
  });

  Color get _priorityColor {
    switch (task.priority?.toLowerCase()) {
      case 'high':
        return const Color(0xFFE17055);
      case 'medium':
        return const Color(0xFFFDAA3B);
      case 'low':
        return const Color(0xFF00B894);
      default:
        return _C.border;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _C.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _C.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top row ──────────────────────────────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Completion toggle
                GestureDetector(
                  onTap: onComplete,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: task.completed ? _C.teal : Colors.transparent,
                      border: Border.all(
                        color: task.completed ? _C.teal : _C.border,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: task.completed
                        ? const Icon(Icons.check_rounded,
                            color: Colors.white, size: 16)
                        : null,
                  ),
                ),
                const SizedBox(width: 12),
                // Title + badges
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.name,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: task.completed ? _C.sub : _C.label,
                          decoration: task.completed
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          decorationColor: _C.sub,
                        ),
                      ),
                      if (task.description.isNotEmpty) ...[
                        const SizedBox(height: 3),
                        Text(
                          task.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 12, color: _C.sub),
                        ),
                      ],
                    ],
                  ),
                ),
                // Actions
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _iconBtn(
                        Icons.edit_rounded, _C.teal, onEdit),
                    _iconBtn(
                        Icons.delete_rounded,
                        Colors.redAccent,
                        onDelete),
                  ],
                ),
              ],
            ),

            // ── Chips row ─────────────────────────────────────────────────────
            if (_hasChips) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  if (task.category != null)
                    _chip(task.category!, Icons.folder_rounded,
                        _C.teal, _C.tealLight),
                  if (task.priority != null)
                    _chip(task.priority!, Icons.flag_rounded,
                        _priorityColor,
                        _priorityColor.withValues(alpha: 0.12)),
                  if (task.dueDate != null)
                    _chip(
                      "${task.dueDate!.day}/${task.dueDate!.month}/${task.dueDate!.year}",
                      Icons.calendar_today_rounded,
                      const Color(0xFF6C5CE7),
                      const Color(0xFFF0EEFF),
                    ),
                  if (task.isImportant)
                    _chip("Important", Icons.star_rounded,
                        const Color(0xFFFDAA3B),
                        const Color(0xFFFFF8E6)),
                  if (task.reminderEnabled)
                    _chip("Reminder",
                        Icons.notifications_active_rounded,
                        const Color(0xFF0984E3),
                        const Color(0xFFEBF5FF)),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  bool get _hasChips =>
      task.category != null ||
      task.priority != null ||
      task.dueDate != null ||
      task.isImportant ||
      task.reminderEnabled;

  Widget _iconBtn(IconData icon, Color color, VoidCallback onTap) =>
      Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Icon(icon, size: 18, color: color),
          ),
        ),
      );

  Widget _chip(String label, IconData icon, Color color, Color bg) =>
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 11, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      );
}