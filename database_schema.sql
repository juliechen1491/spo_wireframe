-- ========================================
-- 運動行政系統 (SPO) 資料庫架構
-- Database Schema for Sports Program Organization System
-- 版本: 1.1.0
-- 建立日期: 2025/10/22
-- ========================================

-- 設定字符集和時區
SET NAMES utf8mb4;
SET time_zone = '+08:00';

-- ========================================
-- 1. 系統管理相關資料表
-- ========================================

-- 系統權限表
CREATE TABLE `system_permissions` (
  `permission_id` int(11) NOT NULL AUTO_INCREMENT,
  `permission_code` varchar(50) NOT NULL COMMENT '權限代碼',
  `permission_name` varchar(100) NOT NULL COMMENT '權限名稱',
  `description` text COMMENT '權限描述',
  `module` varchar(50) NOT NULL COMMENT '所屬模組',
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`permission_id`),
  UNIQUE KEY `uk_permission_code` (`permission_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系統權限表';

-- 角色表
CREATE TABLE `system_roles` (
  `role_id` int(11) NOT NULL AUTO_INCREMENT,
  `role_name` varchar(50) NOT NULL COMMENT '角色名稱',
  `role_code` varchar(30) NOT NULL COMMENT '角色代碼',
  `description` text COMMENT '角色描述',
  `is_active` tinyint(1) DEFAULT 1 COMMENT '是否啟用 (1:啟用, 0:停用)',
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`role_id`),
  UNIQUE KEY `uk_role_code` (`role_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系統角色表';

-- 角色權限關聯表
CREATE TABLE `role_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `role_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_role_permission` (`role_id`, `permission_id`),
  FOREIGN KEY (`role_id`) REFERENCES `system_roles` (`role_id`) ON DELETE CASCADE,
  FOREIGN KEY (`permission_id`) REFERENCES `system_permissions` (`permission_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='角色權限關聯表';

-- ========================================
-- 2. 用戶管理相關資料表
-- ========================================

-- 用戶主表
CREATE TABLE `users` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL COMMENT '用戶名',
  `email` varchar(100) NOT NULL COMMENT '電子信箱',
  `password_hash` varchar(255) NOT NULL COMMENT '加密密碼',
  `full_name` varchar(100) NOT NULL COMMENT '真實姓名',
  `phone` varchar(20) COMMENT '手機號碼',
  `gender` enum('M','F','O') DEFAULT NULL COMMENT '性別 (M:男, F:女, O:其他)',
  `birth_date` date COMMENT '出生日期',
  `id_number` varchar(20) COMMENT '身份證字號/護照號碼',
  `address` text COMMENT '聯絡地址',
  `emergency_contact_name` varchar(100) COMMENT '緊急聯絡人姓名',
  `emergency_contact_phone` varchar(20) COMMENT '緊急聯絡人電話',
  `profile_image` varchar(255) COMMENT '大頭貼URL',
  `status` enum('active','inactive','suspended') DEFAULT 'active' COMMENT '帳戶狀態',
  `email_verified` tinyint(1) DEFAULT 0 COMMENT '信箱是否驗證',
  `last_login_at` timestamp NULL COMMENT '最後登入時間',
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `uk_username` (`username`),
  UNIQUE KEY `uk_email` (`email`),
  KEY `idx_phone` (`phone`),
  KEY `idx_id_number` (`id_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用戶主表';

-- 用戶角色關聯表
CREATE TABLE `user_roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `role_id` int(11) NOT NULL,
  `assigned_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  `assigned_by` int(11) COMMENT '分配者用戶ID',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_role` (`user_id`, `role_id`),
  FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  FOREIGN KEY (`role_id`) REFERENCES `system_roles` (`role_id`) ON DELETE CASCADE,
  FOREIGN KEY (`assigned_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用戶角色關聯表';

-- 監護人關聯表 (兒童學員與監護人的關係)
CREATE TABLE `guardian_relationships` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `student_user_id` int(11) NOT NULL COMMENT '學員用戶ID',
  `guardian_user_id` int(11) NOT NULL COMMENT '監護人用戶ID',
  `relationship` varchar(20) NOT NULL COMMENT '關係 (父親/母親/其他)',
  `is_primary` tinyint(1) DEFAULT 0 COMMENT '是否為主要監護人',
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`student_user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  FOREIGN KEY (`guardian_user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='監護人關聯表';

-- ========================================
-- 3. 學校管理相關資料表
-- ========================================

-- 學校表
CREATE TABLE `schools` (
  `school_id` int(11) NOT NULL AUTO_INCREMENT,
  `school_name` varchar(100) NOT NULL COMMENT '學校名稱',
  `school_code` varchar(20) NOT NULL COMMENT '學校代碼',
  `description` text COMMENT '學校描述',
  `address` text NOT NULL COMMENT '學校地址',
  `phone` varchar(20) COMMENT '聯絡電話',
  `email` varchar(100) COMMENT '聯絡信箱',
  `website` varchar(255) COMMENT '官方網站',
  `logo_url` varchar(255) COMMENT '學校LOGO URL',
  `cover_image_url` varchar(255) COMMENT '封面圖片 URL',
  `established_year` int(4) COMMENT '成立年份',
  `facilities` json COMMENT '設施資訊 (JSON格式)',
  `operating_hours` json COMMENT '營業時間 (JSON格式)',
  `status` enum('active','inactive','suspended') DEFAULT 'active' COMMENT '學校狀態',
  `sort_order` int(11) DEFAULT 0 COMMENT '排序順序',
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`school_id`),
  UNIQUE KEY `uk_school_code` (`school_code`),
  KEY `idx_status` (`status`),
  KEY `idx_sort_order` (`sort_order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='學校表';

-- 學校管理員關聯表
CREATE TABLE `school_administrators` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `school_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `role` enum('owner','admin','staff') DEFAULT 'staff' COMMENT '管理角色',
  `permissions` json COMMENT '特殊權限設定',
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_school_user` (`school_id`, `user_id`),
  FOREIGN KEY (`school_id`) REFERENCES `schools` (`school_id`) ON DELETE CASCADE,
  FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='學校管理員關聯表';

-- ========================================
-- 4. 教練管理相關資料表
-- ========================================

-- 教練表
CREATE TABLE `coaches` (
  `coach_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '對應用戶ID',
  `school_id` int(11) NOT NULL COMMENT '所屬學校ID',
  `coach_code` varchar(20) NOT NULL COMMENT '教練編號',
  `specialties` json COMMENT '專長項目 (JSON陣列)',
  `certifications` json COMMENT '證照資訊 (JSON格式)',
  `experience_years` int(3) COMMENT '教學經驗年數',
  `bio` text COMMENT '個人簡介',
  `achievements` text COMMENT '主要成就',
  `hourly_rate` decimal(8,2) COMMENT '時薪',
  `profile_image_url` varchar(255) COMMENT '教練照片URL',
  `status` enum('active','inactive','on_leave') DEFAULT 'active' COMMENT '教練狀態',
  `hire_date` date COMMENT '聘用日期',
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`coach_id`),
  UNIQUE KEY `uk_coach_code` (`coach_code`),
  FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  FOREIGN KEY (`school_id`) REFERENCES `schools` (`school_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='教練表';

-- 教練可用時間表
CREATE TABLE `coach_availability` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `coach_id` int(11) NOT NULL,
  `day_of_week` tinyint(1) NOT NULL COMMENT '星期幾 (0=周日, 1=周一...6=周六)',
  `start_time` time NOT NULL COMMENT '開始時間',
  `end_time` time NOT NULL COMMENT '結束時間',
  `is_available` tinyint(1) DEFAULT 1 COMMENT '是否可用',
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`coach_id`) REFERENCES `coaches` (`coach_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='教練可用時間表';

-- ========================================
-- 5. 課程管理相關資料表
-- ========================================

-- 課程分類表
CREATE TABLE `course_categories` (
  `category_id` int(11) NOT NULL AUTO_INCREMENT,
  `category_name` varchar(50) NOT NULL COMMENT '分類名稱',
  `category_code` varchar(20) NOT NULL COMMENT '分類代碼',
  `description` text COMMENT '分類描述',
  `icon_url` varchar(255) COMMENT '圖示URL',
  `color_code` varchar(7) COMMENT '主題色彩 (#RRGGBB)',
  `sort_order` int(11) DEFAULT 0 COMMENT '排序順序',
  `is_active` tinyint(1) DEFAULT 1 COMMENT '是否啟用',
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`category_id`),
  UNIQUE KEY `uk_category_code` (`category_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='課程分類表';

-- 課程主表
CREATE TABLE `courses` (
  `course_id` int(11) NOT NULL AUTO_INCREMENT,
  `school_id` int(11) NOT NULL COMMENT '所屬學校ID',
  `category_id` int(11) NOT NULL COMMENT '課程分類ID',
  `course_name` varchar(100) NOT NULL COMMENT '課程名稱',
  `course_code` varchar(30) NOT NULL COMMENT '課程代碼',
  `description` text COMMENT '課程描述',
  `objectives` text COMMENT '學習目標',
  `prerequisites` text COMMENT '先修條件',
  `age_min` int(3) COMMENT '最低年齡',
  `age_max` int(3) COMMENT '最高年齡',
  `difficulty_level` enum('beginner','intermediate','advanced') NOT NULL COMMENT '難度等級',
  `duration_weeks` int(3) COMMENT '課程週數',
  `sessions_per_week` int(2) DEFAULT 1 COMMENT '每週堂數',
  `session_duration` int(3) COMMENT '每堂課時長(分鐘)',
  `max_students` int(3) COMMENT '最大學員數',
  `price` decimal(8,2) NOT NULL COMMENT '課程費用',
  `equipment_needed` text COMMENT '所需設備',
  `image_url` varchar(255) COMMENT '課程圖片URL',
  `status` enum('draft','active','suspended','archived') DEFAULT 'draft' COMMENT '課程狀態',
  `featured` tinyint(1) DEFAULT 0 COMMENT '是否推薦課程',
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`course_id`),
  UNIQUE KEY `uk_course_code` (`course_code`),
  KEY `idx_school_category` (`school_id`, `category_id`),
  KEY `idx_status` (`status`),
  KEY `idx_age_range` (`age_min`, `age_max`),
  FOREIGN KEY (`school_id`) REFERENCES `schools` (`school_id`) ON DELETE CASCADE,
  FOREIGN KEY (`category_id`) REFERENCES `course_categories` (`category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='課程主表';

-- 課程梯次表 (開課時間表)
CREATE TABLE `course_sessions` (
  `session_id` int(11) NOT NULL AUTO_INCREMENT,
  `course_id` int(11) NOT NULL COMMENT '課程ID',
  `session_name` varchar(100) NOT NULL COMMENT '梯次名稱 (如：2025年11月班)',
  `start_date` date NOT NULL COMMENT '開課日期',
  `end_date` date NOT NULL COMMENT '結課日期',
  `schedule_days` json NOT NULL COMMENT '上課日期 (JSON陣列)',
  `schedule_time` time NOT NULL COMMENT '上課時間',
  `location` varchar(255) COMMENT '上課地點',
  `current_enrollment` int(3) DEFAULT 0 COMMENT '目前報名人數',
  `max_enrollment` int(3) COMMENT '最大招生數',
  `registration_start` datetime COMMENT '報名開始時間',
  `registration_end` datetime COMMENT '報名截止時間',
  `status` enum('upcoming','open','full','closed','cancelled') DEFAULT 'upcoming' COMMENT '梯次狀態',
  `notes` text COMMENT '備註說明',
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`session_id`),
  KEY `idx_course_dates` (`course_id`, `start_date`, `end_date`),
  KEY `idx_status` (`status`),
  FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='課程梯次表';

-- 課程教練關聯表
CREATE TABLE `course_coaches` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `session_id` int(11) NOT NULL COMMENT '梯次ID',
  `coach_id` int(11) NOT NULL COMMENT '教練ID',
  `role` enum('primary','assistant','substitute') DEFAULT 'primary' COMMENT '教練角色',
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_session_coach_role` (`session_id`, `coach_id`, `role`),
  FOREIGN KEY (`session_id`) REFERENCES `course_sessions` (`session_id`) ON DELETE CASCADE,
  FOREIGN KEY (`coach_id`) REFERENCES `coaches` (`coach_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='課程教練關聯表';

-- ========================================
-- 6. 報名管理相關資料表
-- ========================================

-- 報名主表
CREATE TABLE `registrations` (
  `registration_id` int(11) NOT NULL AUTO_INCREMENT,
  `registration_number` varchar(20) NOT NULL COMMENT '報名編號 (如：SPO-2025-001234)',
  `session_id` int(11) NOT NULL COMMENT '課程梯次ID',
  `student_user_id` int(11) NOT NULL COMMENT '學員用戶ID',
  `guardian_user_id` int(11) COMMENT '監護人用戶ID (兒童課程必填)',
  `registrant_user_id` int(11) NOT NULL COMMENT '報名者用戶ID (實際操作報名的人)',
  `emergency_contact_name` varchar(100) NOT NULL COMMENT '緊急聯絡人姓名',
  `emergency_contact_phone` varchar(20) NOT NULL COMMENT '緊急聯絡人電話',
  `emergency_contact_relation` varchar(20) COMMENT '緊急聯絡人關係',
  `student_height` decimal(5,2) COMMENT '學員身高 (cm)',
  `health_conditions` text COMMENT '健康狀況/運動受傷史',
  `exercise_experience` text COMMENT '運動經驗',
  `competition_experience` text COMMENT '參賽經驗',
  `current_ability_level` enum('beginner','intermediate','advanced') COMMENT '目前能力程度',
  `training_expectations` text COMMENT '訓練期望',
  `weekly_training_hours` int(3) COMMENT '每週可訓練時數',
  `occupation` varchar(100) COMMENT '職業 (成人學員)',
  `registered_events` text COMMENT '已報名賽事',
  `invoice_type` enum('paper','electronic_mobile','electronic_company') NOT NULL COMMENT '發票類型',
  `invoice_details` json COMMENT '發票詳細資訊 (JSON格式)',
  `bank_last_five_digits` varchar(5) COMMENT '匯款帳號後五碼',
  `registration_fee` decimal(8,2) NOT NULL COMMENT '報名費用',
  `status` enum('pending','confirmed','cancelled','completed') DEFAULT 'pending' COMMENT '報名狀態',
  `admin_notes` text COMMENT '管理員備註',
  `registered_at` timestamp DEFAULT CURRENT_TIMESTAMP COMMENT '報名時間',
  `confirmed_at` timestamp NULL COMMENT '確認時間',
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`registration_id`),
  UNIQUE KEY `uk_registration_number` (`registration_number`),
  KEY `idx_session_student` (`session_id`, `student_user_id`),
  KEY `idx_status` (`status`),
  KEY `idx_registered_at` (`registered_at`),
  FOREIGN KEY (`session_id`) REFERENCES `course_sessions` (`session_id`),
  FOREIGN KEY (`student_user_id`) REFERENCES `users` (`user_id`),
  FOREIGN KEY (`guardian_user_id`) REFERENCES `users` (`user_id`),
  FOREIGN KEY (`registrant_user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='報名主表';

-- ========================================
-- 7. 付款管理相關資料表
-- ========================================

-- 付款紀錄表
CREATE TABLE `payments` (
  `payment_id` int(11) NOT NULL AUTO_INCREMENT,
  `registration_id` int(11) NOT NULL COMMENT '報名ID',
  `payment_number` varchar(20) NOT NULL COMMENT '付款編號',
  `amount` decimal(8,2) NOT NULL COMMENT '付款金額',
  `payment_method` enum('bank_transfer','credit_card','cash','other') NOT NULL COMMENT '付款方式',
  `payment_status` enum('pending','completed','failed','refunded') DEFAULT 'pending' COMMENT '付款狀態',
  `bank_account_last_digits` varchar(5) COMMENT '銀行帳戶後幾碼',
  `transaction_reference` varchar(100) COMMENT '交易參考號',
  `receipt_url` varchar(255) COMMENT '收據/憑證URL',
  `payment_date` datetime COMMENT '付款日期',
  `confirmed_at` timestamp NULL COMMENT '確認時間',
  `confirmed_by` int(11) COMMENT '確認人員ID',
  `refund_amount` decimal(8,2) DEFAULT 0 COMMENT '退款金額',
  `refund_reason` text COMMENT '退款原因',
  `notes` text COMMENT '付款備註',
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`payment_id`),
  UNIQUE KEY `uk_payment_number` (`payment_number`),
  KEY `idx_registration` (`registration_id`),
  KEY `idx_payment_status` (`payment_status`),
  KEY `idx_payment_date` (`payment_date`),
  FOREIGN KEY (`registration_id`) REFERENCES `registrations` (`registration_id`),
  FOREIGN KEY (`confirmed_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='付款紀錄表';

-- ========================================
-- 8. 系統設定與日誌相關資料表
-- ========================================

-- 系統設定表
CREATE TABLE `system_settings` (
  `setting_id` int(11) NOT NULL AUTO_INCREMENT,
  `setting_key` varchar(100) NOT NULL COMMENT '設定鍵值',
  `setting_value` text COMMENT '設定值',
  `setting_type` enum('string','integer','boolean','json') DEFAULT 'string' COMMENT '資料類型',
  `description` varchar(255) COMMENT '設定說明',
  `is_public` tinyint(1) DEFAULT 0 COMMENT '是否為公開設定',
  `updated_by` int(11) COMMENT '更新者ID',
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`setting_id`),
  UNIQUE KEY `uk_setting_key` (`setting_key`),
  FOREIGN KEY (`updated_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系統設定表';

-- 操作日誌表
CREATE TABLE `activity_logs` (
  `log_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) COMMENT '操作用戶ID',
  `action` varchar(50) NOT NULL COMMENT '操作動作',
  `entity_type` varchar(50) COMMENT '操作對象類型',
  `entity_id` int(11) COMMENT '操作對象ID',
  `description` varchar(500) COMMENT '操作描述',
  `ip_address` varchar(45) COMMENT 'IP地址',
  `user_agent` varchar(500) COMMENT '用戶代理',
  `request_data` json COMMENT '請求資料 (JSON)',
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`log_id`),
  KEY `idx_user_action` (`user_id`, `action`),
  KEY `idx_entity` (`entity_type`, `entity_id`),
  KEY `idx_created_at` (`created_at`),
  FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='操作日誌表';

-- ========================================
-- 9. 通知與訊息相關資料表
-- ========================================

-- 通知表
CREATE TABLE `notifications` (
  `notification_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '接收用戶ID',
  `type` varchar(50) NOT NULL COMMENT '通知類型',
  `title` varchar(200) NOT NULL COMMENT '通知標題',
  `message` text NOT NULL COMMENT '通知內容',
  `data` json COMMENT '相關資料 (JSON)',
  `is_read` tinyint(1) DEFAULT 0 COMMENT '是否已讀',
  `read_at` timestamp NULL COMMENT '閱讀時間',
  `priority` enum('low','normal','high','urgent') DEFAULT 'normal' COMMENT '優先級',
  `expires_at` timestamp NULL COMMENT '過期時間',
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`notification_id`),
  KEY `idx_user_read` (`user_id`, `is_read`),
  KEY `idx_type_priority` (`type`, `priority`),
  KEY `idx_created_at` (`created_at`),
  FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='通知表';

-- ========================================
-- 10. 檔案管理相關資料表
-- ========================================

-- 檔案上傳表
CREATE TABLE `file_uploads` (
  `file_id` int(11) NOT NULL AUTO_INCREMENT,
  `original_name` varchar(255) NOT NULL COMMENT '原始檔名',
  `stored_name` varchar(255) NOT NULL COMMENT '儲存檔名',
  `file_path` varchar(500) NOT NULL COMMENT '檔案路徑',
  `file_size` bigint(20) NOT NULL COMMENT '檔案大小 (bytes)',
  `mime_type` varchar(100) COMMENT 'MIME類型',
  `file_type` enum('image','document','video','audio','other') COMMENT '檔案類型',
  `entity_type` varchar(50) COMMENT '關聯實體類型',
  `entity_id` int(11) COMMENT '關聯實體ID',
  `uploaded_by` int(11) COMMENT '上傳者ID',
  `is_public` tinyint(1) DEFAULT 0 COMMENT '是否公開',
  `download_count` int(11) DEFAULT 0 COMMENT '下載次數',
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`file_id`),
  KEY `idx_entity` (`entity_type`, `entity_id`),
  KEY `idx_uploaded_by` (`uploaded_by`),
  KEY `idx_file_type` (`file_type`),
  FOREIGN KEY (`uploaded_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='檔案上傳表';

-- ========================================
-- 初始資料插入 (Sample Data)
-- ========================================

-- 插入系統權限
INSERT INTO `system_permissions` (`permission_code`, `permission_name`, `description`, `module`) VALUES
('system.admin', '系統管理', '完整系統管理權限', 'system'),
('school.manage', '學校管理', '學校資料增刪改查', 'school'),
('course.manage', '課程管理', '課程資料增刪改查', 'course'),
('user.manage', '用戶管理', '用戶資料增刪改查', 'user'),
('coach.manage', '教練管理', '教練資料增刪改查', 'coach'),
('registration.manage', '報名管理', '報名資料增刪改查', 'registration'),
('payment.manage', '付款管理', '付款資料增刪改查', 'payment'),
('report.view', '報表檢視', '檢視各類報表', 'report');

-- 插入系統角色
INSERT INTO `system_roles` (`role_name`, `role_code`, `description`) VALUES
('超級管理員', 'super_admin', '擁有所有系統權限'),
('系統管理員', 'admin', '系統管理與維護'),
('學校管理員', 'school_admin', '學校相關管理權限'),
('教練', 'coach', '教練相關權限'),
('學員', 'student', '學員基本權限'),
('家長', 'parent', '家長/監護人權限');

-- 插入課程分類
INSERT INTO `course_categories` (`category_name`, `category_code`, `description`, `color_code`, `sort_order`) VALUES
('游泳', 'swimming', '各種游泳課程', '#3b82f6', 1),
('跑步', 'running', '跑步訓練課程', '#ef4444', 2),
('自行車', 'cycling', '自行車訓練課程', '#22c55e', 3),
('鐵人三項', 'triathlon', '鐵人三項綜合訓練', '#f59e0b', 4),
('體適能', 'fitness', '一般體適能訓練', '#8b5cf6', 5);

-- 插入系統設定
INSERT INTO `system_settings` (`setting_key`, `setting_value`, `setting_type`, `description`, `is_public`) VALUES
('system.name', '運動行政系統', 'string', '系統名稱', 1),
('system.version', '1.1.0', 'string', '系統版本', 1),
('registration.auto_confirm', 'false', 'boolean', '報名是否自動確認', 0),
('payment.bank_account', '012-345-678901', 'string', '收款銀行帳號', 1),
('payment.bank_name', '台灣銀行 (004)', 'string', '收款銀行名稱', 1),
('payment.deadline_days', '3', 'integer', '繳費截止天數', 0),
('line.official_id', '@spo_admin', 'string', 'LINE官方帳號ID', 1);

-- ========================================
-- 建立索引以提升查詢效能
-- ========================================

-- 複合索引
CREATE INDEX `idx_registrations_status_date` ON `registrations` (`status`, `registered_at`);
CREATE INDEX `idx_course_sessions_dates_status` ON `course_sessions` (`start_date`, `end_date`, `status`);
CREATE INDEX `idx_users_status_created` ON `users` (`status`, `created_at`);
CREATE INDEX `idx_payments_status_date` ON `payments` (`payment_status`, `payment_date`);

-- 全文檢索索引 (用於搜尋功能)
ALTER TABLE `schools` ADD FULLTEXT(`school_name`, `description`);
ALTER TABLE `courses` ADD FULLTEXT(`course_name`, `description`);
ALTER TABLE `users` ADD FULLTEXT(`full_name`, `username`, `email`);

-- ========================================
-- 視圖 (Views) 建立
-- ========================================

-- 報名詳細資訊視圖
CREATE VIEW `v_registration_details` AS
SELECT 
    r.registration_id,
    r.registration_number,
    r.status as registration_status,
    r.registered_at,
    r.registration_fee,
    -- 學員資訊
    s.full_name as student_name,
    s.email as student_email,
    s.phone as student_phone,
    -- 監護人資訊  
    g.full_name as guardian_name,
    g.email as guardian_email,
    g.phone as guardian_phone,
    -- 課程資訊
    c.course_name,
    cs.session_name,
    cs.start_date,
    cs.end_date,
    -- 學校資訊
    sch.school_name,
    -- 付款資訊
    p.payment_status,
    p.payment_date,
    p.amount as payment_amount
FROM registrations r
LEFT JOIN users s ON r.student_user_id = s.user_id
LEFT JOIN users g ON r.guardian_user_id = g.user_id
LEFT JOIN course_sessions cs ON r.session_id = cs.session_id
LEFT JOIN courses c ON cs.course_id = c.course_id
LEFT JOIN schools sch ON c.school_id = sch.school_id
LEFT JOIN payments p ON r.registration_id = p.registration_id;

-- 課程統計視圖
CREATE VIEW `v_course_statistics` AS
SELECT 
    c.course_id,
    c.course_name,
    s.school_name,
    cat.category_name,
    COUNT(DISTINCT cs.session_id) as total_sessions,
    COUNT(DISTINCT r.registration_id) as total_registrations,
    SUM(CASE WHEN r.status = 'confirmed' THEN 1 ELSE 0 END) as confirmed_registrations,
    SUM(CASE WHEN cs.status = 'open' THEN 1 ELSE 0 END) as open_sessions,
    AVG(c.price) as average_price
FROM courses c
LEFT JOIN schools s ON c.school_id = s.school_id
LEFT JOIN course_categories cat ON c.category_id = cat.category_id
LEFT JOIN course_sessions cs ON c.course_id = cs.course_id
LEFT JOIN registrations r ON cs.session_id = r.session_id
GROUP BY c.course_id, c.course_name, s.school_name, cat.category_name;

-- ========================================
-- 觸發器 (Triggers) 建立
-- ========================================

-- 自動生成報名編號
DELIMITER $$
CREATE TRIGGER `tr_generate_registration_number` BEFORE INSERT ON `registrations`
FOR EACH ROW BEGIN
    DECLARE next_number INT;
    DECLARE year_part VARCHAR(4);
    
    SET year_part = YEAR(NOW());
    
    SELECT COALESCE(MAX(CAST(SUBSTRING(registration_number, -6) AS UNSIGNED)), 0) + 1 
    INTO next_number
    FROM registrations 
    WHERE registration_number LIKE CONCAT('SPO-', year_part, '-%');
    
    SET NEW.registration_number = CONCAT('SPO-', year_part, '-', LPAD(next_number, 6, '0'));
END$$
DELIMITER ;

-- 更新課程梯次報名人數
DELIMITER $$
CREATE TRIGGER `tr_update_enrollment_count` AFTER INSERT ON `registrations`
FOR EACH ROW BEGIN
    UPDATE course_sessions 
    SET current_enrollment = (
        SELECT COUNT(*) 
        FROM registrations 
        WHERE session_id = NEW.session_id 
        AND status IN ('confirmed', 'pending')
    )
    WHERE session_id = NEW.session_id;
END$$
DELIMITER ;

-- ========================================
-- 存儲過程 (Stored Procedures)
-- ========================================

-- 獲取用戶報名歷史
DELIMITER $$
CREATE PROCEDURE `sp_get_user_registration_history`(
    IN p_user_id INT,
    IN p_limit INT DEFAULT 10,
    IN p_offset INT DEFAULT 0
)
BEGIN
    SELECT 
        r.registration_number,
        r.status,
        r.registered_at,
        c.course_name,
        cs.session_name,
        s.school_name,
        r.registration_fee,
        p.payment_status
    FROM registrations r
    LEFT JOIN course_sessions cs ON r.session_id = cs.session_id
    LEFT JOIN courses c ON cs.course_id = c.course_id
    LEFT JOIN schools s ON c.school_id = s.school_id
    LEFT JOIN payments p ON r.registration_id = p.registration_id
    WHERE r.student_user_id = p_user_id OR r.registrant_user_id = p_user_id
    ORDER BY r.registered_at DESC
    LIMIT p_limit OFFSET p_offset;
END$$
DELIMITER ;

-- ========================================
-- 授權與安全設定
-- ========================================

-- 創建應用程式專用用戶 (建議在生產環境中使用)
-- CREATE USER 'spo_app'@'localhost' IDENTIFIED BY 'secure_password_here';
-- GRANT SELECT, INSERT, UPDATE, DELETE ON spo_system.* TO 'spo_app'@'localhost';
-- FLUSH PRIVILEGES;

-- ========================================
-- 備份與維護建議
-- ========================================

/*
建議的維護作業:

1. 定期備份
   - 每日完整備份: mysqldump --single-transaction spo_system > backup_$(date +%Y%m%d).sql
   - 增量備份: 啟用 binary logging

2. 索引維護
   - 定期分析表: ANALYZE TABLE table_name;
   - 檢查索引使用情況: SHOW INDEX FROM table_name;

3. 日誌清理
   - 定期清理舊日誌: DELETE FROM activity_logs WHERE created_at < DATE_SUB(NOW(), INTERVAL 90 DAY);
   - 定期清理舊通知: DELETE FROM notifications WHERE created_at < DATE_SUB(NOW(), INTERVAL 30 DAY) AND is_read = 1;

4. 效能監控
   - 監控慢查詢日誌
   - 定期檢查表大小和成長趨勢
   - 監控連線數和記憶體使用量
*/

-- ========================================
-- Schema 建立完成
-- ========================================

-- 顯示所有建立的表格
SHOW TABLES;

-- 顯示資料庫基本統計
SELECT 
    COUNT(*) as total_tables,
    SUM(CASE WHEN table_type = 'BASE TABLE' THEN 1 ELSE 0 END) as base_tables,
    SUM(CASE WHEN table_type = 'VIEW' THEN 1 ELSE 0 END) as views
FROM information_schema.tables 
WHERE table_schema = DATABASE();

SELECT '運動行政系統資料庫 Schema 建立完成！' as status;