# Implementation Plan: Database Backup and Recovery

## Overview

This plan implements database backup and recovery functionality for super administrators. The implementation follows the existing hexagonal architecture pattern and integrates with the current authorization system.

## Tasks

- [x] 1. Create domain layer components
  - [x] 1.1 Create BackupStatus enum
    - Create `BackupStatus.java` in `domain/enums` package
    - Define IN_PROGRESS, SUCCESS, FAILED values
    - _Requirements: 1.3, 1.4_

  - [x] 1.2 Create BackupRecord entity
    - Create `BackupRecord.java` in `domain/entities` package
    - Define fields: id, filename, createdAt, fileSizeBytes, status, errorMessage, lastRestoredAt, createdBy
    - Add JPA annotations for table mapping
    - _Requirements: 1.3, 4.3_

  - [x] 1.3 Create backup exception classes
    - Create `BackupException.java` in `domain/exceptions` package
    - Create `BackupNotFoundException.java` in `domain/exceptions` package
    - Create `BackupFileNotFoundException.java` in `domain/exceptions` package
    - _Requirements: 1.4, 3.2, 4.4_

- [x] 2. Create infrastructure layer components
  - [x] 2.1 Create BackupRecordRepository interface
    - Create `BackupRecordRepository.java` in `domain/ports` package
    - Extend JpaRepository with BackupRecord and Long
    - Add method `findAllByOrderByCreatedAtDesc()`
    - _Requirements: 2.1_

  - [x] 2.2 Create PostgresBackupExecutor interface and implementation
    - Create `PostgresBackupExecutor.java` interface in `domain/ports` package
    - Create `PostgresBackupExecutorImpl.java` in `infrastructure/adapters` package
    - Implement createDump() using ProcessBuilder to run pg_dump
    - Implement restoreFromDump() using ProcessBuilder to run pg_restore
    - _Requirements: 1.1, 4.1_

  - [x] 2.3 Create backup configuration properties
    - Create `BackupProperties.java` in `infrastructure/config` package
    - Define properties: directory, postgres host/port/database/username/password
    - Add @ConfigurationProperties annotation
    - Update application.properties with backup.* properties
    - _Requirements: 6.1, 6.2, 6.3_

- [x] 3. Create application layer components
  - [x] 3.1 Create BackupService interface
    - Create `BackupService.java` interface in `application/services` package
    - Define methods: createBackup, listBackups, getBackup, downloadBackup, restoreFromBackup, deleteBackup
    - _Requirements: 1.1, 2.1, 3.1, 4.1, 5.1_

  - [x] 3.2 Implement BackupServiceImpl
    - Create `BackupServiceImpl.java` in `application/services` package
    - Inject BackupRecordRepository, PostgresBackupExecutor, BackupProperties
    - Implement createBackup() with filename generation and record creation
    - Implement listBackups() with descending order
    - Implement getBackup() with not-found handling
    - Implement downloadBackup() with file resource loading
    - Implement restoreFromBackup() with pre-restore backup
    - Implement deleteBackup() with file and record removal
    - _Requirements: 1.1, 1.2, 1.3, 2.1, 3.1, 4.1, 4.2, 4.3, 5.1_

  - [x] 3.4 Write property test for backup filename format
    - **Property 2: Backup Filename Format**
    - Test that generated filenames match pattern `intelliquiz_backup_YYYY-MM-DDTHH-mm-ss.sql`
    - **Validates: Requirements 1.2**

  - [x] 3.5 Write property test for backup record completeness
    - **Property 3: Backup Record Completeness**
    - Test that successful backups create records with all required fields
    - **Validates: Requirements 1.3**

  - [x] 3.6 Write property test for list ordering
    - **Property 4: Backup List Ordering**
    - Test that listBackups returns records ordered by createdAt descending
    - **Validates: Requirements 2.1**

  - [x] 3.3 Extend AuthorizationService
    - Add `requireSuperAdmin(User user)` method to existing AuthorizationService
    - Throw AuthorizationException if user is not SUPER_ADMIN
    - _Requirements: 1.5, 2.3, 3.3, 4.5, 5.3_

- [x] 4. Create presentation layer components
  - [x] 4.1 Create BackupRecordDTO
    - Create `BackupRecordDTO.java` record in `presentation/dto` package
    - Define fields matching BackupRecord entity
    - Add static fromEntity() factory method
    - _Requirements: 2.2_

  - [x] 4.2 Create BackupController
    - Create `BackupController.java` in `presentation/controllers` package
    - Implement POST /api/backups endpoint for createBackup
    - Implement GET /api/backups endpoint for listBackups
    - Implement GET /api/backups/{id} endpoint for getBackup
    - Implement GET /api/backups/{id}/download endpoint for downloadBackup
    - Implement POST /api/backups/{id}/restore endpoint for restoreBackup
    - Implement DELETE /api/backups/{id} endpoint for deleteBackup
    - Add authorization checks using AuthorizationService.requireSuperAdmin()
    - Add OpenAPI annotations for Swagger documentation
    - _Requirements: 1.1, 1.5, 2.1, 2.3, 3.1, 3.3, 4.1, 4.5, 5.1, 5.3_

  - [x] 4.3 Create BackupExceptionHandler
    - Create `BackupExceptionHandler.java` in `presentation/controllers` package
    - Add @RestControllerAdvice annotation
    - Handle BackupNotFoundException with 404 response
    - Handle BackupFileNotFoundException with 404 response
    - Handle BackupException with 500 response
    - _Requirements: 1.4, 3.2, 4.4_

  - [x] 4.4 Write property test for authorization enforcement
    - **Property 1: Authorization Enforcement**
    - Test that all backup operations reject non-super-admin users
    - **Validates: Requirements 1.5, 2.3, 3.3, 4.5, 5.3**

- [x] 5. Checkpoint - Ensure all tests pass
  - Ensure all tests pass, ask the user if questions arise.

- [x] 6. Create backup directory initialization
  - [x] 6.1 Create BackupDirectoryInitializer
    - Create `BackupDirectoryInitializer.java` in `infrastructure/config` package
    - Implement ApplicationRunner to create backup directory on startup
    - Validate directory is writable
    - Log warning if directory creation fails
    - _Requirements: 6.2, 6.3_

- [x] 7. Write integration tests
  - [x] 7.1 Write integration test for backup creation
    - Test end-to-end backup creation with actual pg_dump
    - Verify file is created and record is persisted
    - _Requirements: 1.1, 1.2, 1.3_

  - [x] 7.2 Write integration test for backup restore
    - Test end-to-end restore with actual pg_restore
    - Verify pre-restore backup is created
    - Verify lastRestoredAt is updated
    - _Requirements: 4.1, 4.2, 4.3_

  - [x] 7.3 Write property test for delete completeness
    - **Property 8: Delete Removes Record and File**
    - Test that delete removes both BackupRecord and physical file
    - **Validates: Requirements 5.1**

- [x] 8. Final checkpoint - Ensure all tests pass
  - Ensure all tests pass, ask the user if questions arise.

## Notes

- All tasks are required for comprehensive implementation
- Each task references specific requirements for traceability
- Checkpoints ensure incremental validation
- Property tests validate universal correctness properties using jqwik
- Unit tests validate specific examples and edge cases
- The implementation uses ProcessBuilder to execute pg_dump and pg_restore commands
