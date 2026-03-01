import 'package:auto_routine/colors.dart';
import 'package:auto_routine/profile.dart';
import 'package:auto_routine/tasks/add_task.dart';
import 'package:auto_routine/tasks/delete_task.dart';
import 'package:auto_routine/tasks/edit_task.dart';
import 'package:auto_routine/tasks/task_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum SortOption {
  priority('Priority'),
  dueDate('Due Date'),
  lastUpdated('Last Updated');

  final String label;
  const SortOption(this.label);
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: themeNotifier,
      builder: (context, light, _) {
        return Scaffold(
          backgroundColor: light ? appBackground[0] : appBackground[1],
          body: IndexedStack(
            index: _currentIndex,
            children: [
              _HomeBody(isLight: light),
              CurrentuserDetails(),
            ],
          ),
          floatingActionButton: _currentIndex == 0
              ? FloatingActionButton(
                  onPressed: () => addTask(context),
                  backgroundColor: primaryAccent,
                  child: const Icon(Icons.add),
                )
              : null,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            backgroundColor: light ? appBackground[0] : appBackground[1],
            selectedItemColor: primaryAccent,
            unselectedItemColor: light ? secondaryText[0] : secondaryText[1],
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HomeBody extends StatefulWidget {
  const _HomeBody({required this.isLight});

  final bool isLight;

  @override
  State<_HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<_HomeBody> {
  final Set<String> _selectedIds = {};
  SortOption _sortBy = SortOption.lastUpdated;

  bool get _isSelecting => _selectedIds.isNotEmpty;

  void _toggleSelection(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  void _selectAll(List<Task> tasks) {
    setState(() {
      _selectedIds.addAll(tasks.map((t) => t.id));
    });
  }

  void _clearSelection() {
    setState(() => _selectedIds.clear());
  }

  Future<void> _deleteSelected() async {
    final count = _selectedIds.length;
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return ValueListenableBuilder<bool>(
          valueListenable: themeNotifier,
          builder: (ctx, light, _) {
            return AlertDialog(
              backgroundColor: light ? appBackground[0] : appBackground[1],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(
                'Delete Tasks',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: light ? primaryText[0] : primaryText[1],
                ),
              ),
              content: Text(
                'Are you sure you want to delete $count selected task${count > 1 ? 's' : ''}?',
                style: TextStyle(
                  color: light ? secondaryText[0] : secondaryText[1],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: light ? secondaryText[0] : secondaryText[1],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(ctx).pop(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Delete',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    if (confirmed != true) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final batch = FirebaseFirestore.instance.batch();
    for (final id in _selectedIds) {
      batch.delete(
        FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('tasks')
            .doc(id),
      );
    }
    await batch.commit();
    _clearSelection();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const SizedBox.shrink();
    }

    return Scaffold(
      backgroundColor: widget.isLight ? appBackground[0] : appBackground[1],
      appBar: AppBar(
        backgroundColor: widget.isLight ? appBackground[0] : appBackground[1],
        leading: _isSelecting
            ? IconButton(
                icon: Icon(
                  Icons.close,
                  color: widget.isLight ? primaryText[0] : primaryText[1],
                ),
                onPressed: _clearSelection,
                tooltip: 'Cancel selection',
              )
            : null,
        title: Text(
          _isSelecting ? '${_selectedIds.length} selected' : 'My Tasks',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: widget.isLight ? primaryText[0] : primaryText[1],
          ),
        ),
        centerTitle: !_isSelecting,
        actions: _isSelecting
            ? [
                ElevatedButton.icon(
                  label: Text(
                    'Select All',
                    style: TextStyle(
                      color: widget.isLight ? primaryText[0] : primaryText[1],
                    ),
                  ),
                  icon: Icon(
                    Icons.select_all,
                    color: widget.isLight ? primaryText[0] : primaryText[1],
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.isLight
                        ? appBackground[0]
                        : appBackground[1],
                  ),
                  onPressed: () => _selectAll(_currentTasks),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: _deleteSelected,
                  tooltip: 'Delete selected',
                ),
              ]
            : [
                PopupMenuButton<SortOption>(
                  tooltip: 'Sort by',
                  color: widget.isLight ? appBackground[0] : appBackground[1],
                  onSelected: (value) {
                    setState(() => _sortBy = value);
                  },
                  itemBuilder: (context) => SortOption.values.map((option) {
                    return PopupMenuItem(
                      value: option,
                      child: Row(
                        children: [
                          if (_sortBy == option)
                            const Icon(
                              Icons.check,
                              color: primaryAccent,
                              size: 18,
                            )
                          else
                            const SizedBox(width: 18),
                          const SizedBox(width: 8),
                          Text(
                            option.label,
                            style: TextStyle(
                              color: widget.isLight
                                  ? primaryText[0]
                                  : primaryText[1],
                              fontWeight: _sortBy == option
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.sort,
                        color: widget.isLight ? primaryText[0] : primaryText[1],
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Sorted By ${_sortBy.label}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: widget.isLight
                              ? primaryText[0]
                              : primaryText[1],
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ),
              ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('tasks')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: primaryAccent),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Something went wrong',
                style: TextStyle(
                  color: widget.isLight ? secondaryText[0] : secondaryText[1],
                ),
              ),
            );
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.task_outlined,
                    size: 64,
                    color: widget.isLight ? secondaryText[0] : secondaryText[1],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No tasks yet',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: widget.isLight
                          ? secondaryText[0]
                          : secondaryText[1],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap + to add your first task',
                    style: TextStyle(
                      fontSize: 14,
                      color: widget.isLight
                          ? secondaryText[0]
                          : secondaryText[1],
                    ),
                  ),
                ],
              ),
            );
          }

          final tasks = docs.map((doc) => Task.fromFirestore(doc)).toList();
          _sortTasks(tasks);
          _currentTasks = tasks;

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return _TaskTile(
                task: task,
                isLight: widget.isLight,
                isSelected: _selectedIds.contains(task.id),
                isSelecting: _isSelecting,
                onLongPress: () => _toggleSelection(task.id),
                onTap: _isSelecting ? () => _toggleSelection(task.id) : null,
              );
            },
          );
        },
      ),
    );
  }

  List<Task> _currentTasks = [];

  void _sortTasks(List<Task> tasks) {
    switch (_sortBy) {
      case SortOption.dueDate:
        tasks.sort((a, b) {
          if (a.dueDate == null && b.dueDate == null) return 0;
          if (a.dueDate == null) return 1;
          if (b.dueDate == null) return -1;
          return a.dueDate!.compareTo(b.dueDate!);
        });
      case SortOption.priority:
        tasks.sort((a, b) => b.priority.index.compareTo(a.priority.index));
      case SortOption.lastUpdated:
        tasks.sort((a, b) => b.lastUpdated.compareTo(a.lastUpdated));
    }
  }
}

class _TaskTile extends StatelessWidget {
  const _TaskTile({
    required this.task,
    required this.isLight,
    required this.isSelected,
    required this.isSelecting,
    required this.onLongPress,
    this.onTap,
  });

  final Task task;
  final bool isLight;
  final bool isSelected;
  final bool isSelecting;
  final VoidCallback onLongPress;
  final VoidCallback? onTap;

  Future<void> _toggleComplete() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('tasks')
        .doc(task.id)
        .update({
          'isCompleted': !task.isCompleted,
          'lastUpdated': FieldValue.serverTimestamp(),
        });
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    final dateTimeFormat = DateFormat('MMM dd, yyyy  hh:mm a');

    return GestureDetector(
      onLongPress: onLongPress,
      onTap: onTap,
      child: Card(
        color: isSelected
            ? (isLight ? secondaryAccent[0] : secondaryAccent[1])
            : (isLight
                  ? Colors.grey.shade100
                  : Colors.white.withValues(alpha: 0.08)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: isSelected
              ? const BorderSide(color: primaryAccent, width: 1.5)
              : BorderSide.none,
        ),
        margin: const EdgeInsets.symmetric(vertical: 6),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: checkbox, title, actions
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: 4),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isLight ? primaryText[0] : primaryText[1],
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                            decorationColor: isLight
                                ? secondaryText[0]
                                : secondaryText[1],
                          ),
                        ),
                        if (task.description.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            task.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: isLight
                                  ? secondaryText[0]
                                  : secondaryText[1],
                              decoration: task.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                              decorationColor: isLight
                                  ? secondaryText[0]
                                  : secondaryText[1],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (!isSelecting) ...[
                    IconButton(
                      icon: Icon(
                        Icons.edit_outlined,
                        color: isLight ? secondaryText[0] : secondaryText[1],
                        size: 20,
                      ),
                      onPressed: () => editTask(context, task),
                      tooltip: 'Edit',
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.all(6),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.redAccent,
                        size: 20,
                      ),
                      onPressed: () => deleteTask(context, task),
                      tooltip: 'Delete',
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.all(6),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 10),
              // Priority & Due Date row
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: task.priority.color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      task.priority.label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: task.priority.color,
                      ),
                    ),
                  ),
                  if (task.dueDate != null) ...[
                    const SizedBox(width: 10),
                    Icon(
                      Icons.calendar_today,
                      size: 13,
                      color: _isDueOverdue(task.dueDate!)
                          ? Colors.redAccent
                          : (isLight ? secondaryText[0] : secondaryText[1]),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      dateFormat.format(task.dueDate!),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: _isDueOverdue(task.dueDate!)
                            ? Colors.redAccent
                            : (isLight ? secondaryText[0] : secondaryText[1]),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),
              // Created & Updated row
              Row(
                children: [
                  Text(
                    'Created: ${dateTimeFormat.format(task.createdAt)}',
                    style: TextStyle(
                      fontSize: 11,
                      color: isLight
                          ? secondaryText[0].withValues(alpha: 0.7)
                          : secondaryText[1].withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Text(
                    'Updated: ${dateTimeFormat.format(task.lastUpdated)}',
                    style: TextStyle(
                      fontSize: 11,
                      color: isLight
                          ? secondaryText[0].withValues(alpha: 0.7)
                          : secondaryText[1].withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isDueOverdue(DateTime dueDate) {
    final now = DateTime.now();
    return DateTime(
      dueDate.year,
      dueDate.month,
      dueDate.day,
    ).isBefore(DateTime(now.year, now.month, now.day));
  }
}
