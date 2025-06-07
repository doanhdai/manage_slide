const express = require("express");
const mysql = require("mysql2");
const cors = require("cors");
const app = express();
app.use(cors());
app.use(express.json());

// Cấu hình kết nối MySQL or PostgreSQL
const db = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "",
  database: "lessonsdb",
});

// Lấy tất cả lecture requests
app.get("/api/lecture-requests", (req, res) => {
  const sql = `
    SELECT *
    FROM lectures lr
    JOIN users u ON lr.user_id = u.id
    JOIN lectures l ON lr.id = l.id
    ORDER BY lr.created_at DESC;
  `;
  db.query(sql, (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(results);
  });
});

// create request
app.post("/api/lecture-requests", (req, res) => {
  const {
    lecture_name,
    subject,
    chapter,
    link_genspack,
    description,
    user_id,
  } = req.body;

  // Kiểm tra dữ liệu đầu vào
  if (!lecture_name || !subject || !chapter || !user_id) {
    return res.status(400).json({ error: "Thiếu các trường bắt buộc" });
  }

  const sql = `
    INSERT INTO lectures (lecture_name, subject, chapter, link_genspack, status, user_id, created_at, description)
    VALUES (?, ?, ?, ?, 'New', '1', NOW(), ?)
  `;
  const values = [
    lecture_name,
    subject,
    chapter,
    link_genspack || "",
    description || "",
    user_id,
  ];

  db.query(sql, values, (err, result) => {
    if (err) {
      console.error("Lỗi khi thêm bài giảng:", err);
      return res.status(500).json({ error: "Không thể thêm bài giảng" });
    }
    res.status(201).json({
      message: "Thêm bài giảng thành công",
      id: result.insertId,
      lecture_name,
      subject,
      chapter,
      link_genspack,
      description,
      status: 'New',
      //full_name: 'Admin'
    });
  });
});

// Cập nhật mô tả bài giảng
app.patch("/api/lecture-requests/:id", (req, res) => {
  const lectureId = req.params.id;
  const { description } = req.body;

  // Kiểm tra trạng thái bài giảng
  const checkStatusSql = "SELECT status FROM lectures WHERE id = ?";
  db.query(checkStatusSql, [lectureId], (err, results) => {
    if (err) {
      console.error("Lỗi khi kiểm tra trạng thái:", err);
      return res.status(500).json({ error: "Lỗi server" });
    }

    if (results.length === 0) {
      return res.status(404).json({ error: "Không tìm thấy bài giảng" });
    }

    if (results[0].status !== "New") {
      return res.status(403).json({
        error: "Chỉ có thể cập nhật mô tả khi bài giảng ở trạng thái Mới",
      });
    }

    // Cập nhật mô tả
    const updateSql = "UPDATE lectures SET description = ? WHERE id = ?";
    db.query(updateSql, [description, lectureId], (err, result) => {
      if (err) {
        console.error("Lỗi khi cập nhật mô tả:", err);
        return res.status(500).json({ error: "Không thể cập nhật mô tả" });
      }
      res.json({ message: "Cập nhật mô tả thành công" });
    });
  });
});

// Xóa bài giảng
app.delete("/api/lecture-requests/:id", (req, res) => {
  const lectureId = req.params.id;

  // Kiểm tra xem bài giảng có tồn tại không
  const checkSql = "SELECT id FROM lectures WHERE id = ?";
  db.query(checkSql, [lectureId], (err, results) => {
    if (err) {
      console.error("Lỗi khi kiểm tra bài giảng:", err);
      return res.status(500).json({ error: "Lỗi server" });
    }

    if (results.length === 0) {
      return res.status(404).json({ error: "Không tìm thấy bài giảng" });
    }

    // Thực hiện xóa
    const deleteSql = "DELETE FROM lectures WHERE id = ?";
    db.query(deleteSql, [lectureId], (err, result) => {
      if (err) {
        console.error("Lỗi khi xóa bài giảng:", err);
        return res.status(500).json({ error: "Không thể xóa bài giảng" });
      }
      res.json({ message: "Xóa bài giảng thành công" });
    });
  });
});
// create infor slide
app.post("/api/createSlide", (req, res) => {
  const slides = req.body.slides; // Lấy mảng slides từ client

  if (!Array.isArray(slides) || slides.length === 0) {
    return res.status(400).json({ error: "Slides không hợp lệ hoặc trống" });
  }

  // Duyệt từng slide để kiểm tra và insert
  for (const slide of slides) {
    const { lecture_id, title, html_content, slide_order } = slide;

    if (!lecture_id || !title || !html_content) {
      return res
        .status(400)
        .json({ error: "Thiếu trường bắt buộc trong slide" });
    }

    const sqlCreateSlide = `INSERT INTO slides (lecture_id,title,html_content,slide_order,created_at) VALUES (?,?, ?, ?, NOW())`;

    const values = [lecture_id, title, html_content, slide_order || null];

    db.query(sqlCreateSlide, values, (err, result) => {
      if (err) {
        console.error("Lỗi khi thêm slide:", err);
        return res.status(500).json({ error: "Không thể thêm slide" });
      }
    });
  
  const sqlUpdateStatus = `UPDATE lectures SET status = 'created' WHERE id = ?`;
  const lectureId = [lecture_id]
  db.query(sqlUpdateStatus, [lectureId], (updateErr) => {
    if (updateErr) {
      console.error("Lỗi khi cập nhật trạng thái bài giảng:", updateErr);
      return res
        .status(500)
        .json({
          error:
            "Thêm slide xong nhưng không cập nhật được trạng thái bài giảng",
        });
    }

    res
      .status(201)
      .json({ message: "Thêm slide và cập nhật bài giảng thành công" });
  })};
});

// Get slides by lecture ID
app.get("/api/slides/:lectureId", (req, res) => {
  const lectureId = req.params.lectureId;
  
  const sql = `
    SELECT * FROM slides 
    WHERE lecture_id = ? 
    ORDER BY slide_order ASC
  `;
  
  db.query(sql, [lectureId], (err, results) => {
    if (err) {
      console.error("Lỗi khi lấy slides:", err);
      return res.status(500).json({ error: "Không thể lấy slides" });
    }
    res.json(results);
  });
});

// Start server
app.listen(3000, () => {
  console.log("Server is running on http://localhost:3000");
});
