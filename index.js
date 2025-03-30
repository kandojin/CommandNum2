const express = require('express');
const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');
const cors = require('cors');
const jwt = require("jsonwebtoken");

const app = express();
app.use(express.json());
app.use(cors());  // Разрешает запросы с Flutter

mongoose.connect('mongodb://localhost:27017/users', {
    useNewUrlParser: true, 
    useUnifiedTopology: true 
}).then(() => console.log('MongoDB connected'))
  .catch(err => console.error('MongoDB connection error:', err));

  const UserSchema = mongoose.Schema({
    full_name: { type: String, required: true },
    iin: { type: String, required: true },
    address: { type: String, required: true },
    name: { type: String, required: true }, // Никнейм или краткое имя
    email: { type: String, unique: true, required: true },
    password: { type: String, required: true },
    role: { type: String, required: true, default: "user" }
});

const UserModel = mongoose.model('users', UserSchema);

const MessageSchema = mongoose.Schema({
    from: { type: mongoose.Schema.Types.ObjectId, ref: 'users', required: true },
    to: { type: mongoose.Schema.Types.ObjectId, ref: 'users', required: true },
    text: { type: String, required: true },
    createdAt: { type: Date, default: Date.now }
});

const MessageModel = mongoose.model('messages', MessageSchema);

app.post('/send-message', async (req, res) => {
    const token = req.headers.authorization?.split(" ")[1];
    if (!token) return res.status(401).json({ message: 'Unauthorized' });

    try {
        const decoded = jwt.verify(token, "ключ");
        const { to, text } = req.body;

        const newMessage = new MessageModel({
            from: decoded.id,
            to,
            text
        });

        await newMessage.save();
        res.json({ message: 'Сообщение отправлено' });
    } catch (error) {
        res.status(500).json({ message: 'Ошибка при отправке сообщения' });
    }
});

app.get('/messages/:withUserId', async (req, res) => {
    const token = req.headers.authorization?.split(" ")[1];
    if (!token) return res.status(401).json({ message: 'Unauthorized' });

    try {
        const decoded = jwt.verify(token, "ключ");
        const { withUserId } = req.params;

        const messages = await MessageModel.find({
            $or: [
                { from: decoded.id, to: withUserId },
                { from: withUserId, to: decoded.id }
            ]
        }).sort({ createdAt: 1 });

        res.json(messages);
    } catch (error) {
        res.status(500).json({ message: 'Ошибка при получении сообщений' });
    }
});

app.get('/', (req, res) => {
    res.send('Server is running...');
});

app.get("/check-admin/:userId", async (req, res) => {
    try {
        const user = await UserModel.findById(req.params.userId);
        if (!user) return res.status(404).json({ error: "User not found" });

        res.json({ isAdmin: user.role === "admin" });
    } catch (error) {
        res.status(500).json({ error: "Server error" });
    }
});



app.get('/account', async (req, res) => {
    const token = req.headers.authorization?.split(" ")[1]; // Получаем токен из заголовков

    if (!token) {
        return res.status(401).json({ message: 'Unauthorized' });
    }

    try {
        const decoded = jwt.verify(token, "f0eacfdb77d8652c250f7bfd62d38c1103962633fee7c98e5d76c13b2ec63b26"); // Расшифровываем токен
        const user = await UserModel.findById(decoded.id).select('-password'); // Получаем пользователя без пароля

        if (!user) {
            return res.status(404).json({ message: 'User not found' });
        }

        // Возвращаем все нужные поля
        res.json({
            full_name: user.full_name,
            iin: user.iin,
            address: user.address,
            name: user.name,
            email: user.email,
            role: user.role
        });
    } catch (error) {
        res.status(401).json({ message: 'Invalid token' });
    }
});


// Регистрация
app.post('/register', async (req, res) => {
    const { full_name, iin, address, name, email, password } = req.body;

    // Проверка на наличие всех данных
    if (!full_name || !iin || !address || !name || !email || !password) {
        return res.status(400).json({ message: 'Все поля обязательны для заполнения' });
    }

    try {
        // Проверка на существующего пользователя (по email)
        const existingUser = await UserModel.findOne({ email });
        if (existingUser) {
            return res.status(400).json({ message: 'Пользователь с таким email уже существует' });
        }

        // Хэшируем пароль
        const hashedPassword = await bcrypt.hash(password, 10);

        // Создаем нового пользователя
        const newUser = new UserModel({
            full_name,
            iin,
            address,
            name,
            email,
            password: hashedPassword,
            role: "user"
        });

        await newUser.save();

        res.json({ message: 'Пользователь успешно зарегистрирован' });
    } catch (error) {
        res.status(500).json({ message: 'Ошибка при регистрации пользователя', error: error.message });
    }
});
app.post('/sos', async (req, res) => {
    const token = req.headers.authorization?.split(" ")[1];

    if (!token) {
        return res.status(401).json({ message: 'Unauthorized' });
    }

    try {
        // Расшифровка токена
        const decoded = jwt.verify(token, "f0eacfdb77d8652c250f7bfd62d38c1103962633fee7c98e5d76c13b2ec63b26");

        // Поиск пользователя по id
        const user = await UserModel.findById(decoded.id).select('-password');

        if (!user) {
            return res.status(404).json({ message: 'User not found' });
        }

        // Получаем координаты из запроса
        const { latitude, longitude } = req.body;

        console.log('=== SOS ===');
        console.log('Пользователь:', user);
        console.log('Координаты:', latitude, longitude);

        res.json({ message: 'SOS получен' });

    } catch (error) {
        res.status(401).json({ message: 'Invalid token' });
    }
});


// Логин
app.post('/login', async (req, res) => {
    const { email, password } = req.body;

    try {
        // Поиск пользователя по email
        const user = await UserModel.findOne({ email });

        if (!user) {
            return res.status(400).json({ message: 'Пользователь не найден' });
        }

        // Проверка пароля
        const isMatch = await bcrypt.compare(password, user.password);
        if (!isMatch) {
            return res.status(400).json({ message: 'Неверный пароль' });
        }

        // Генерация JWT-токена
        const token = jwt.sign(
            { id: user._id, role: user.role }, 
            "f0eacfdb77d8652c250f7bfd62d38c1103962633fee7c98e5d76c13b2ec63b26", 
            { expiresIn: "1h" }
        );


        res.json({ message: 'Вход выполнен успешно', token, role: user.role });
    } catch (error) {
        res.status(500).json({ message: 'Ошибка сервера', error: error.message });
    }
});



app.listen(5000,  () => {
    console.log('Server is running on http://localhost:5000');
});
