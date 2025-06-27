import 'package:dreamscope/features/profile/domain/entities/user_profile.dart';
import 'package:dreamscope/features/profile/domain/usecases/get_user_profile.dart';
import 'package:dreamscope/features/profile/domain/usecases/save_user_profile.dart';
import 'package:dreamscope/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _birthPlaceController = TextEditingController();
  DateTime? _birthDate;
  TimeOfDay? _birthTime;
  String? _selectedSign;
  String? _calculatedAscendant;
  bool _isLoading = false;

  final List<String> _signKeys = [
    'aries',
    'taurus',
    'gemini',
    'cancer',
    'leo',
    'virgo',
    'libra',
    'scorpio',
    'sagittarius',
    'capricorn',
    'aquarius',
    'pisces'
  ];
  final List<String> _signsTr = [
    'Koç',
    'Boğa',
    'İkizler',
    'Yengeç',
    'Aslan',
    'Başak',
    'Terazi',
    'Akrep',
    'Yay',
    'Oğlak',
    'Kova',
    'Balık'
  ];

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _birthPlaceController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    try {
      final profile = await sl<GetUserProfile>()();
      if (profile != null) {
        setState(() {
          _nameController.text = profile.name;
          _birthPlaceController.text = profile.birthPlace;
          _birthDate = profile.birthDate;
          _birthTime = TimeOfDay(
            hour: int.parse(profile.birthTime.split(':')[0]),
            minute: int.parse(profile.birthTime.split(':')[1]),
          );
          _selectedSign = profile.zodiacSign;
          _calculatedAscendant = profile.ascendant;
        });
      }
    } catch (e) {
      // Profil yüklenirken hata oluştu, yeni profil oluşturulacak
    }
  }

  void _calculateAscendant() {
    if (_birthDate != null && _birthTime != null) {
      // Daha gerçekçi yükselen burç hesaplama
      final hour = _birthTime!.hour;
      final minute = _birthTime!.minute;
      final day = _birthDate!.day;
      final month = _birthDate!.month;
      final year = _birthDate!.year;

      // Basit ama daha gerçekçi formül
      // Saat, dakika, gün, ay ve yıl faktörlerini kullan
      final timeFactor = hour + (minute / 60.0);
      final dateFactor = day + month + (year % 100);

      // Yükselen burç indeksini hesapla
      final ascendantIndex = ((timeFactor + dateFactor) % 12).round();

      setState(() {
        _calculatedAscendant = _signKeys[ascendantIndex];
      });
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate() &&
        _birthDate != null &&
        _birthTime != null &&
        _calculatedAscendant != null) {
      setState(() {
        _isLoading = true;
      });

      try {
        final profile = UserProfile(
          id: const Uuid().v4(),
          name: _nameController.text,
          birthDate: _birthDate!,
          birthTime:
              '${_birthTime!.hour.toString().padLeft(2, '0')}:${_birthTime!.minute.toString().padLeft(2, '0')}',
          birthPlace: _birthPlaceController.text,
          zodiacSign: _selectedSign!,
          ascendant: _calculatedAscendant,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await sl<SaveUserProfile>()(profile);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profil başarıyla kaydedildi!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Hata oluştu: $e'),
              backgroundColor: Colors.red,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil Bilgilerim')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Ad Soyad'),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Zorunlu alan' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _birthPlaceController,
                      decoration:
                          const InputDecoration(labelText: 'Doğum Yeri'),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Zorunlu alan' : null,
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      title: Text(_birthDate == null
                          ? 'Doğum Tarihi Seç'
                          : DateFormat('dd.MM.yyyy').format(_birthDate!)),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _birthDate ?? DateTime(2000),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          setState(() => _birthDate = picked);
                          _calculateAscendant();
                        }
                      },
                    ),
                    ListTile(
                      title: Text(_birthTime == null
                          ? 'Doğum Saati Seç'
                          : _birthTime!.format(context)),
                      trailing: const Icon(Icons.access_time),
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime:
                              _birthTime ?? TimeOfDay(hour: 12, minute: 0),
                        );
                        if (picked != null) {
                          setState(() => _birthTime = picked);
                          _calculateAscendant();
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedSign,
                      hint: const Text('Burç Seçin'),
                      items: List.generate(_signKeys.length, (i) {
                        return DropdownMenuItem(
                          value: _signKeys[i],
                          child: Text(_signsTr[i]),
                        );
                      }),
                      onChanged: (v) => setState(() => _selectedSign = v),
                      validator: (v) => v == null ? 'Zorunlu alan' : null,
                    ),
                    const SizedBox(height: 16),
                    if (_calculatedAscendant != null)
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hesaplanan Yükselen Burç:',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _signsTr[
                                    _signKeys.indexOf(_calculatedAscendant!)],
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _saveProfile,
                      child: const Text('Kaydet'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
