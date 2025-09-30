class ModificationHistory {
  final String operatorId;
  final List<ModificationEntry> entries;

  ModificationHistory({
    required this.operatorId,
    required this.entries,
  });

  // Méthode pour générer des données fictives pour un opérateur
  static ModificationHistory generateMockDataForOperator(String operatorId) {
    return ModificationHistory(
      operatorId: operatorId,
      entries: [
        ModificationEntry(
          id: '1',
          date: DateTime.now().subtract(const Duration(days: 2)),
          modifiedBy: 'Admin',
          modificationReason: 'Mise à jour du statut',
          fieldName: 'Statut',
          oldValue: 'Inactif',
          newValue: 'Actif',
          modificationType: ModificationType.statusChange,
        ),
        ModificationEntry(
          id: '2',
          date: DateTime.now().subtract(const Duration(days: 5)),
          modifiedBy: 'Superviseur',
          modificationReason: 'Changement de rôle',
          fieldName: 'Rôle',
          oldValue: 'Agent Junior',
          newValue: 'Agent Senior',
          modificationType: ModificationType.roleChange,
        ),
        ModificationEntry(
          id: '3',
          date: DateTime.now().subtract(const Duration(days: 10)),
          modifiedBy: 'RH',
          modificationReason: 'Mise à jour des informations personnelles',
          fieldName: 'Numéro de téléphone',
          oldValue: '+237 655 123 456',
          newValue: '+237 655 789 012',
          modificationType: ModificationType.infoChange,
        ),
        ModificationEntry(
          id: '4',
          date: DateTime.now().subtract(const Duration(days: 15)),
          modifiedBy: 'Admin',
          modificationReason: 'Changement d\'équipe',
          fieldName: 'Équipe',
          oldValue: 'Support Niveau 1',
          newValue: 'Support Technique',
          modificationType: ModificationType.teamChange,
        ),
        ModificationEntry(
          id: '5',
          date: DateTime.now().subtract(const Duration(days: 30)),
          modifiedBy: 'Système',
          modificationReason: 'Création du compte',
          fieldName: 'Compte',
          oldValue: 'N/A',
          newValue: 'Créé',
          modificationType: ModificationType.accountCreation,
        ),
      ],
    );
  }
}

class ModificationEntry {
  final String id;
  final DateTime date;
  final String modifiedBy;
  final String modificationReason;
  final String fieldName;
  final String oldValue;
  final String newValue;
  final ModificationType modificationType;

  ModificationEntry({
    required this.id,
    required this.date,
    required this.modifiedBy,
    required this.modificationReason,
    required this.fieldName,
    required this.oldValue,
    required this.newValue,
    required this.modificationType,
  });
}

enum ModificationType {
  statusChange,
  roleChange,
  infoChange,
  teamChange,
  accountCreation,
}
