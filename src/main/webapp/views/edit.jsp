<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="sena.adso.config.DBConnection" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Editar Producto - Panadería</title>
        <!-- Bootstrap CSS para estilos -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Bootstrap Icons para iconos -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.3/font/bootstrap-icons.css">
        <!-- FontAwesome para más iconos -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            body {
                background: linear-gradient(135deg, #fffbe6 0%, #ffe5b4 100%);
                min-height: 100vh;
            }
            .navbar {
                background: linear-gradient(90deg, #ffb347 0%, #ffcc33 100%);
                box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            }
            .card {
                border-radius: 1rem;
                box-shadow: 0 4px 24px rgba(255, 179, 71, 0.15);
            }
            .btn-success, .btn-warning, .btn-danger, .btn-primary {
                border-radius: 2rem;
                font-weight: 600;
                letter-spacing: 0.5px;
            }
            .btn-warning {
                background: linear-gradient(90deg, #ffcc33 0%, #ffb347 100%);
                color: #7c4700;
                border: none;
            }
            .btn-warning:hover {
                background: linear-gradient(90deg, #ffb347 0%, #ffcc33 100%);
                color: #fff;
            }
            .btn-secondary {
                border-radius: 2rem;
                font-weight: 600;
                letter-spacing: 0.5px;
            }
            .form-label i {
                color: #ff7043;
                margin-right: 4px;
            }
            .card-header {
                background: linear-gradient(90deg, #ffb347 0%, #ffcc33 100%);
                color: #7c4700;
                border-top-left-radius: 1rem;
                border-top-right-radius: 1rem;
            }
            .card-title i {
                color: #ff7043;
            }
            .navbar-brand {
                font-family: 'Pacifico', cursive;
                font-size: 2rem;
                color: #7c4700 !important;
                letter-spacing: 1px;
            }
            .main-title {
                color: #7c4700;
                font-family: 'Pacifico', cursive;
                font-size: 2.5rem;
                text-align: center;
                margin-top: 1.5rem;
                margin-bottom: 2rem;
                text-shadow: 1px 2px 8px #ffe5b4;
                letter-spacing: 1px;
            }
        </style>
        <!-- Google Fonts para logo -->
        <link href="https://fonts.googleapis.com/css2?family=Pacifico&display=swap" rel="stylesheet">
    </head>
    <body>
        <nav class="navbar navbar-expand-lg mb-4">
            <div class="container">
                <a class="navbar-brand" href="../index.jsp">
                    <i class="fa-solid fa-bread-slice"></i> Panadería Gestión
                </a>
            </div>
        </nav>
        <div class="container mt-4">
            <div class="main-title">
                <i class="fa-solid fa-pen-to-square"></i> Editar Producto
            </div>
            <%
            String idStr = request.getParameter("id");
            int id = 0;
            String codigo = "";
            String nombre = "";
            String descripcion = "";
            String precio = "";
            String stock = "";
            String categoria = "";
            String mensaje = "";
            boolean exito = false;
            String errorCodigo = "";
            String errorNombre = "";
            String errorDescripcion = "";
            String errorPrecio = "";
            String errorStock = "";
            String errorCategoria = "";
            boolean hayErrores = false;
            String hora_registro = "";
            // Obtener datos actuales si es GET
            if (idStr != null && !idStr.isEmpty()) {
                try {
                    id = Integer.parseInt(idStr);
                } catch (NumberFormatException e) {
                    mensaje = "ID inválido.";
                }
            } else {
                mensaje = "No se proporcionó un ID válido.";
            }
            if (id > 0) {
                if (!"POST".equalsIgnoreCase(request.getMethod())) {
                    // Cargar datos actuales
                    Connection conn = null;
                    PreparedStatement ps = null;
                    ResultSet rs = null;
                    try {
                        conn = DBConnection.getConnection();
                        String query = "SELECT * FROM producto WHERE id = ?";
                        ps = conn.prepareStatement(query);
                        ps.setInt(1, id);
                        rs = ps.executeQuery();
                        if (rs.next()) {
                            codigo = rs.getString("codigo");
                            nombre = rs.getString("nombre");
                            descripcion = rs.getString("descripcion");
                            precio = rs.getString("precio");
                            stock = rs.getString("stock");
                            categoria = rs.getString("categoria");
                            hora_registro = rs.getString("hora_registro");
                        } else {
                            mensaje = "No se encontró el producto.";
                        }
                    } catch (SQLException e) {
                        mensaje = "Error al cargar el producto: " + e.getMessage();
                    } finally {
                        try { if (rs != null) rs.close(); if (ps != null) ps.close(); } catch (SQLException e) { e.printStackTrace(); }
                    }
                } else {
                    // Procesar edición
                    codigo = request.getParameter("codigo");
                    nombre = request.getParameter("nombre");
                    descripcion = request.getParameter("descripcion");
                    precio = request.getParameter("precio");
                    stock = request.getParameter("stock");
                    categoria = request.getParameter("categoria");
                    // Validaciones
                    if (codigo == null || codigo.trim().isEmpty()) {
                        errorCodigo = "El código es obligatorio";
                        hayErrores = true;
                    } else if (codigo.trim().length() < 3) {
                        errorCodigo = "El código debe tener al menos 3 caracteres";
                        hayErrores = true;
                    } else if (!codigo.matches("\\d+")) {
                        errorCodigo = "El código debe contener solo números";
                        hayErrores = true;
                    }
                    if (nombre == null || nombre.trim().isEmpty()) {
                        errorNombre = "El nombre es obligatorio";
                        hayErrores = true;
                    } else if (nombre.trim().length() < 3) {
                        errorNombre = "El nombre debe tener al menos 3 caracteres";
                        hayErrores = true;
                    }
                    if (descripcion == null || descripcion.trim().isEmpty()) {
                        errorDescripcion = "La descripción es obligatoria";
                        hayErrores = true;
                    }
                    if (precio == null || precio.trim().isEmpty()) {
                        errorPrecio = "El precio es obligatorio";
                        hayErrores = true;
                    } else {
                        try { Double.parseDouble(precio); } catch (NumberFormatException e) { errorPrecio = "El precio debe ser un número válido"; hayErrores = true; }
                    }
                    if (stock == null || stock.trim().isEmpty()) {
                        errorStock = "El stock es obligatorio";
                        hayErrores = true;
                    } else {
                        try { Integer.parseInt(stock); } catch (NumberFormatException e) { errorStock = "El stock debe ser un número entero"; hayErrores = true; }
                    }
                    if (categoria == null || categoria.trim().isEmpty()) {
                        errorCategoria = "La categoría es obligatoria";
                        hayErrores = true;
                    }
                    // Si no hay errores, actualizar
                    if (!hayErrores) {
                        Connection conn = null;
                        PreparedStatement ps = null;
                        try {
                            conn = DBConnection.getConnection();
                            // Verificar duplicado de código (excepto el mismo id)
                            String queryVerificar = "SELECT COUNT(*) FROM producto WHERE codigo = ? AND id <> ?";
                            ps = conn.prepareStatement(queryVerificar);
                            ps.setString(1, codigo.trim());
                            ps.setInt(2, id);
                            ResultSet rs = ps.executeQuery();
                            if (rs.next() && rs.getInt(1) > 0) {
                                errorCodigo = "Este código ya está registrado en otro producto";
                                hayErrores = true;
                            } else {
                                rs.close();
                                ps.close();
                                String queryUpdate = "UPDATE producto SET codigo=?, nombre=?, descripcion=?, precio=?, stock=?, categoria=? WHERE id=?";
                                ps = conn.prepareStatement(queryUpdate);
                                ps.setString(1, codigo.trim());
                                ps.setString(2, nombre.trim());
                                ps.setString(3, descripcion.trim());
                                ps.setString(4, precio.trim());
                                ps.setString(5, stock.trim());
                                ps.setString(6, categoria.trim());
                                ps.setInt(7, id);
                                int resultado = ps.executeUpdate();
                                if (resultado > 0) {
                                    mensaje = "Producto actualizado correctamente";
                                    exito = true;
                                } else {
                                    mensaje = "No se pudo actualizar el producto";
                                }
                            }
                        } catch (SQLException e) {
                            mensaje = "Error al actualizar: " + e.getMessage();
                        } finally {
                            try { if (ps != null) ps.close(); } catch (SQLException e) { e.printStackTrace(); }
                        }
                    }
                }
            }
            %>
            <% if (!mensaje.isEmpty()) { %>
                <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
                <script>
                    Swal.fire({
                        icon: '<%= exito ? "success" : "error" %>',
                        title: '<%= exito ? "¡Éxito!" : "Error" %>',
                        text: '<%= mensaje %>',
                        confirmButtonText: 'OK',
                    }).then((result) => {
                        if ('<%= exito ? "true" : "false" %>' === 'true') {
                            window.location.href = '../index.jsp';
                        }
                    });
                    if ('<%= exito ? "true" : "false" %>' === 'true') {
                        setTimeout(function(){ window.location.href = '../index.jsp'; }, 2000);
                    }
                </script>
            <% } %>
            <div class="card shadow">
                <div class="card-body">
                    <form action="edit.jsp?id=<%= id %>" method="POST" id="formEditar" novalidate>
                        <!-- Campo código -->
                        <div class="mb-3">
                            <label for="codigo" class="form-label">
                                <i class="fa-solid fa-credit-card"></i>Código
                            </label>
                            <input type="text" class="form-control <%= errorCodigo.isEmpty() ? "" : "is-invalid" %>" id="codigo" name="codigo" value="<%= codigo != null ? codigo : "" %>" placeholder="Ingrese el código del producto" required>
                            <% if (!errorCodigo.isEmpty()) { %>
                                <div class="invalid-feedback"><%= errorCodigo %></div>
                            <% } %>
                        </div>
                        <!-- Campo nombre -->
                        <div class="mb-3">
                            <label for="nombre" class="form-label">
                                <i class="fa-solid fa-person"></i>Nombre
                            </label>
                            <input type="text" class="form-control <%= errorNombre.isEmpty() ? "" : "is-invalid" %>" id="nombre" name="nombre" value="<%= nombre != null ? nombre : "" %>" placeholder="Ingrese el nombre del producto" required>
                            <% if (!errorNombre.isEmpty()) { %>
                                <div class="invalid-feedback"><%= errorNombre %></div>
                            <% } %>
                        </div>
                        <!-- Campo Descripción -->
                        <div class="mb-3">
                            <label for="descripcion" class="form-label">
                                <i class="fa-solid fa-info-circle"></i>Descripción
                            </label>
                            <input type="text" class="form-control <%= errorDescripcion.isEmpty() ? "" : "is-invalid" %>" id="descripcion" name="descripcion" value="<%= descripcion != null ? descripcion : "" %>" placeholder="Ingrese la descripción del producto" required>
                            <% if (!errorDescripcion.isEmpty()) { %>
                                <div class="invalid-feedback"><%= errorDescripcion %></div>
                            <% } %>
                        </div>
                        <!-- Campo Precio -->
                        <div class="mb-3">
                            <label for="precio" class="form-label">
                                <i class="fa-solid fa-dollar-sign"></i>Precio
                            </label>
                            <input type="text" class="form-control <%= errorPrecio.isEmpty() ? "" : "is-invalid" %>" id="precio" name="precio" value="<%= precio != null ? precio : "" %>" placeholder="Ingrese el precio del producto" required>
                            <% if (!errorPrecio.isEmpty()) { %>
                                <div class="invalid-feedback"><%= errorPrecio %></div>
                            <% } %>
                        </div>
                        <!-- Campo Stock -->
                        <div class="mb-3">
                            <label for="stock" class="form-label">
                                <i class="fa-solid fa-box"></i>Stock
                            </label>
                            <input type="text" class="form-control <%= errorStock.isEmpty() ? "" : "is-invalid" %>" id="stock" name="stock" value="<%= stock != null ? stock : "" %>" placeholder="Ingrese el stock del producto" required>
                            <% if (!errorStock.isEmpty()) { %>
                                <div class="invalid-feedback"><%= errorStock %></div>
                            <% } %>
                        </div>
                        <!-- Campo Categoría -->
                        <div class="mb-3">
                            <label for="categoria" class="form-label">
                                <i class="fa-solid fa-tags"></i>Categoría
                            </label>
                            <input type="text" class="form-control <%= errorCategoria.isEmpty() ? "" : "is-invalid" %>" id="categoria" name="categoria" value="<%= categoria != null ? categoria : "" %>" placeholder="Ingrese la categoría del producto" required>
                            <% if (!errorCategoria.isEmpty()) { %>
                                <div class="invalid-feedback"><%= errorCategoria %></div>
                            <% } %>
                        </div>
                        <!-- Botones de acción -->
                        <div class="d-flex justify-content-between mt-4">
                            <a href="../index.jsp" class="btn btn-secondary">
                                <i class="fa-solid fa-arrow-left"></i>Cancelar
                            </a>
                            <button type="submit" class="btn btn-warning">
                                <i class="fa-solid fa-save"></i>Guardar Cambios
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        <!-- Scripts de Bootstrap -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
