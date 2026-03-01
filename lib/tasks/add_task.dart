import 'package:auto_routine/colors.dart';
import 'package:auto_routine/tasks/task_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<void> addTask(BuildContext context) async {
  final titleController = TextEditingController();
  final descController = TextEditingController();
  Priority selectedPriority = Priority.low;
  DateTime? selectedDueDate;

  final confirmed = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) {
      return StatefulBuilder(
        builder: (ctx, setDialogState) {
          final light = isLight;
          return AlertDialog(
            backgroundColor: light ? appBackground[0] : appBackground[1],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              'Add Task',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: light ? primaryText[0] : primaryText[1],
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    style: TextStyle(
                      color: light ? primaryText[0] : primaryText[1],
                    ),
                    decoration: InputDecoration(
                      hintText: 'Task title',
                      hintStyle: TextStyle(
                        color: light ? secondaryText[0] : secondaryText[1],
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: light ? secondaryText[0] : secondaryText[1],
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: primaryAccent),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: descController,
                    maxLines: 3,
                    style: TextStyle(
                      color: light ? primaryText[0] : primaryText[1],
                    ),
                    decoration: InputDecoration(
                      hintText: 'Description (optional)',
                      hintStyle: TextStyle(
                        color: light ? secondaryText[0] : secondaryText[1],
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: light ? secondaryText[0] : secondaryText[1],
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: primaryAccent),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<Priority>(
                    value: selectedPriority,
                    dropdownColor: light ? appBackground[0] : appBackground[1],
                    style: TextStyle(
                      color: light ? primaryText[0] : primaryText[1],
                    ),
                    decoration: InputDecoration(
                      labelText: 'Priority',
                      labelStyle: TextStyle(
                        color: light ? secondaryText[0] : secondaryText[1],
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: light ? secondaryText[0] : secondaryText[1],
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: primaryAccent),
                      ),
                    ),
                    items: Priority.values.map((p) {
                      return DropdownMenuItem(
                        value: p,
                        child: Text(p.label, style: TextStyle(color: p.color)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setDialogState(() => selectedPriority = value);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: ctx,
                        initialDate: selectedDueDate ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setDialogState(() => selectedDueDate = picked);
                      }
                    },
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Due Date',
                        labelStyle: TextStyle(
                          color: light ? secondaryText[0] : secondaryText[1],
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: light ? secondaryText[0] : secondaryText[1],
                          ),
                        ),
                        suffixIcon: selectedDueDate != null
                            ? IconButton(
                                icon: Icon(
                                  Icons.clear,
                                  color: light
                                      ? secondaryText[0]
                                      : secondaryText[1],
                                  size: 20,
                                ),
                                onPressed: () {
                                  setDialogState(() => selectedDueDate = null);
                                },
                              )
                            : Icon(
                                Icons.calendar_today,
                                color: light
                                    ? secondaryText[0]
                                    : secondaryText[1],
                                size: 20,
                              ),
                      ),
                      child: Text(
                        selectedDueDate != null
                            ? DateFormat(
                                'MMM dd, yyyy',
                              ).format(selectedDueDate!)
                            : 'No due date',
                        style: TextStyle(
                          color: selectedDueDate != null
                              ? (light ? primaryText[0] : primaryText[1])
                              : (light ? secondaryText[0] : secondaryText[1]),
                        ),
                      ),
                    ),
                  ),
                ],
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
                  backgroundColor: primaryAccent,
                  foregroundColor: primaryText[0],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Add',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          );
        },
      );
    },
  );

  if (confirmed != true) {
    titleController.dispose();
    descController.dispose();
    return;
  }

  final title = titleController.text.trim();
  final description = descController.text.trim();
  titleController.dispose();
  descController.dispose();

  if (title.isEmpty) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Task title cannot be empty')));
    return;
  }

  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  try {
    final now = FieldValue.serverTimestamp();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('tasks')
        .add({
          'title': title,
          'description': description,
          'isCompleted': false,
          'priority': selectedPriority.name,
          'dueDate': selectedDueDate != null
              ? Timestamp.fromDate(selectedDueDate!)
              : null,
          'createdAt': now,
          'lastUpdated': now,
        });
  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Failed to add task: $e')));
  }
}
