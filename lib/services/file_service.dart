import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

/// 文件管理服务
class FileService {
  static const List<String> videoExtensions = [
    'mp4', 'mkv', 'avi', 'mov', 'flv', 'wmv', 'webm', 'ts', 'mts', 'mtv', 'mts', 'm2ts'
  ];
  
  static const List<String> subtitleExtensions = [
    'srt', 'ass', 'ssa', 'sub', 'vtt', 'sbv'
  ];

  /// 选择视频文件
  static Future<String?> pickVideoFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: videoExtensions,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        return result.files.first.path;
      }
      return null;
    } catch (e) {
      print('Error picking video file: $e');
      return null;
    }
  }

  /// 选择字幕文件
  static Future<String?> pickSubtitleFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: subtitleExtensions,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        return result.files.first.path;
      }
      return null;
    } catch (e) {
      print('Error picking subtitle file: $e');
      return null;
    }
  }

  /// 获取视频文件列表
  static Future<List<FileSystemEntity>> getVideoFilesInDirectory(String dirPath) async {
    try {
      final directory = Directory(dirPath);
      if (!await directory.exists()) {
        return [];
      }

      final files = await directory.list().toList();
      final videoFiles = files.where((file) {
        if (file is File) {
          final extension = file.path.split('.').last.toLowerCase();
          return videoExtensions.contains(extension);
        }
        return false;
      }).toList();

      return videoFiles;
    } catch (e) {
      print('Error getting video files: $e');
      return [];
    }
  }

  /// 获取文件名
  static String getFileName(String filePath) {
    return filePath.split('/').last;
  }

  /// 获取文件大小（MB）
  static Future<double> getFileSize(String filePath) async {
    try {
      final file = File(filePath);
      final bytes = await file.length();
      return bytes / (1024 * 1024);
    } catch (e) {
      print('Error getting file size: $e');
      return 0;
    }
  }

  /// 获取最近打开的视频目录
  static Future<String?> getLastOpenedDirectory() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      return directory.path;
    } catch (e) {
      print('Error getting documents directory: $e');
      return null;
    }
  }

  /// 检查文件是否存在
  static Future<bool> fileExists(String filePath) async {
    try {
      final file = File(filePath);
      return await file.exists();
    } catch (e) {
      print('Error checking file existence: $e');
      return false;
    }
  }

  /// 获取文件修改时间
  static Future<DateTime?> getFileModificationTime(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        final stat = await file.stat();
        return stat.modified;
      }
      return null;
    } catch (e) {
      print('Error getting file modification time: $e');
      return null;
    }
  }
}
