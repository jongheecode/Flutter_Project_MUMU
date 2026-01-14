// lib/screens/upload_screen.dart
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  String _selectedCategory = '자작곡';
  bool _isUploading = false;
  
  String? _musicFilePath;
  String? _coverImagePath;
  String _musicFileName = '';
  String _coverFileName = '';

  Future<void> _pickMusicFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          if (kIsWeb) {
            _musicFilePath = result.files.first.bytes.toString();
            _musicFileName = result.files.first.name;
          } else {
            _musicFilePath = result.files.first.path;
            _musicFileName = result.files.first.name;
          }
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('음악 파일 선택: $_musicFileName'),
            backgroundColor: const Color(0xFFFF2D55),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('음악 파일 선택 에러: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('음악 파일 선택 실패'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _pickCoverImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (image != null) {
        setState(() {
          _coverImagePath = image.path;
          _coverFileName = image.name;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('커버 이미지 선택: $_coverFileName'),
            backgroundColor: const Color(0xFFFF2D55),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('이미지 선택 에러: $e');
    }
  }

  Future<void> _uploadMusic() async {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('제목을 입력해주세요')),
      );
      return;
    }

    setState(() => _isUploading = true);

    try {
      final success = await ApiService.uploadMusic(
        title: _titleController.text,
        category: _selectedCategory,
        content: _descController.text,
        musicFilePath: _musicFilePath,
        coverImagePath: _coverImagePath,
      );

      setState(() => _isUploading = false);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('업로드 성공!'),
            backgroundColor: Color(0xFFFF2D55),
          ),
        );
        Navigator.pop(context, true);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('업로드 실패. 다시 시도해주세요.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('업로드 에러: $e');
      setState(() => _isUploading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('업로드 중 오류: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('음악 업로드'),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _isUploading ? null : _uploadMusic,
            child: _isUploading 
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Color(0xFFFF2D55),
                  ),
                )
              : const Text(
                  '완료',
                  style: TextStyle(
                    color: Color(0xFFFF2D55),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. 앨범 커버 선택 영역
            Center(
              child: GestureDetector(
                onTap: _pickCoverImage,
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1C1C1E),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFFF2D55), width: 2),
                    image: _coverImagePath != null && !kIsWeb
                        ? DecorationImage(
                            image: FileImage(File(_coverImagePath!)),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: _coverImagePath == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.add_photo_alternate, color: Color(0xFFFF2D55), size: 40),
                            SizedBox(height: 8),
                            Text(
                              '커버 이미지 추가',
                              style: TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        )
                      : null,
                ),
              ),
            ),
            if (_coverFileName.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Center(
                  child: Text(
                    _coverFileName,
                    style: const TextStyle(color: Colors.grey, fontSize: 11),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            const SizedBox(height: 30),

            // 2. 제목 입력
            const Text(
              '제목 *',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF1C1C1E),
                hintText: '곡 제목을 입력하세요',
                hintStyle: TextStyle(color: Colors.grey[600]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 3. 카테고리 선택
            const Text(
              '카테고리',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF1C1C1E),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedCategory,
                  dropdownColor: const Color(0xFF1C1C1E),
                  isExpanded: true,
                  style: const TextStyle(color: Colors.white),
                  items: ['자작곡', '커버곡', 'MR/비트', '기타'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) => setState(() => _selectedCategory = newValue!),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 4. 파일 선택
            const Text(
              '음악 파일 *',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickMusicFile,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFFF2D55), width: 2),
                  borderRadius: BorderRadius.circular(8),
                  color: _musicFilePath != null
                      ? const Color(0xFFFF2D55).withOpacity(0.1)
                      : Colors.transparent,
                ),
                child: Column(
                  children: [
                    Icon(
                      _musicFilePath != null ? Icons.check_circle : Icons.audio_file,
                      color: const Color(0xFFFF2D55),
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _musicFileName.isEmpty ? '음원 파일 선택 (.mp3, .wav)' : _musicFileName,
                      style: const TextStyle(
                        color: Color(0xFFFF2D55),
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 5. 설명 입력
            const Text(
              '설명',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _descController,
              style: const TextStyle(color: Colors.white),
              maxLines: 5,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF1C1C1E),
                hintText: '곡에 대한 설명을 적어주세요\n#해시태그도 가능합니다',
                hintStyle: TextStyle(color: Colors.grey[600]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }
}