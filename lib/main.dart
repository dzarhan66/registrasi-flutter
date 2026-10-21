import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Form Registrasi',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const RegistrationFormPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class RegistrationFormPage extends StatefulWidget {
  const RegistrationFormPage({super.key});

  @override
  State<RegistrationFormPage> createState() => _RegistrationFormPageState();
}

class _RegistrationFormPageState extends State<RegistrationFormPage> {
  // GlobalKey untuk mengelola state Form
  final _formKey = GlobalKey<FormState>();

  // TextEditingController untuk mengambil input text
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // FocusNode untuk perpindahan antar field keyboard
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  // State variabel untuk Radio, Dropdown, dan Checkbox
  String? _selectedGender;
  String? _selectedProdi = 'Sistem Informasi'; // Default value
  bool _isAgreed = false;

  // Daftar Pilihan Program Studi
  final List<String> _prodiList = [
    'Teknik Informatika',
    'Sistem Informasi',
    'Teknik Komputer',
    'Data Science',
  ];

  @override
  void dispose() {
    // Memastikan controller dan focusNode dibersihkan saat widget di-destroy
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  // Fungsi saat tombol Daftar ditekan
  void _submitForm() {
    // 1. Cek validasi input text
    if (_formKey.currentState!.validate()) {
      // 2. Cek apakah syarat & ketentuan sudah dicentang
      if (!_isAgreed) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Anda harus menyetujui Syarat & Ketentuan!'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      // 3. Tampilkan AlertDialog konfirmasi jika semua validasi lolos
      _showConfirmationDialog();
    }
  }

  // Fungsi menampilkan AlertDialog Ringkasan Data
  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Pendaftaran'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Nama Lengkap: ${_nameController.text}'),
                const SizedBox(height: 8),
                Text('Email: ${_emailController.text}'),
                const SizedBox(height: 8),
                Text('Jenis Kelamin: ${_selectedGender ?? "Belum dipilih"}'),
                const SizedBox(height: 8),
                Text('Program Studi: ${_selectedProdi ?? "Belum dipilih"}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Submit'),
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Pendaftaran Berhasil!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Registrasi'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Field Nama Lengkap
              TextFormField(
                controller: _nameController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_emailFocusNode);
                },
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Field Email
              TextFormField(
                controller: _emailController,
                focusNode: _emailFocusNode,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_passwordFocusNode);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email tidak boleh kosong';
                  }
                  if (!value.contains('@')) {
                    return 'Email harus mengandung "@"';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Field Password
              TextFormField(
                controller: _passwordController,
                focusNode: _passwordFocusNode,
                obscureText: true,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password tidak boleh kosong';
                  }
                  if (value.length < 6) {
                    return 'Password minimal 6 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Jenis Kelamin (Radio)
              const Text(
                'Jenis Kelamin:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Laki-laki'),
                      value: 'Laki-laki',
                      groupValue: _selectedGender,
                      onChanged: (value) {
                        setState(() {
                          _selectedGender = value;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Perempuan'),
                      value: 'Perempuan',
                      groupValue: _selectedGender,
                      onChanged: (value) {
                        setState(() {
                          _selectedGender = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Program Studi (DropdownButton)
              const Text(
                'Program Studi:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedProdi,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                items: _prodiList.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedProdi = newValue;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Setuju Syarat & Ketentuan (Checkbox)
              CheckboxListTile(
                title: const Text('Saya setuju dengan Syarat & Ketentuan'),
                value: _isAgreed,
                onChanged: (value) {
                  setState(() {
                    _isAgreed = value ?? false;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 24),

              // Tombol Daftar
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text(
                    'Daftar',
                    style: TextStyle(fontSize: 18),
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