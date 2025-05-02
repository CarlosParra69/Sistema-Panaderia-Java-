<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="sena.adso.config.DBConnection" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Agregar Producto - Panadería</title>
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
        .btn-success {
            background: linear-gradient(90deg, #ffb347 0%, #ffcc33 100%);
            color: #7c4700;
            border: none;
        }
        .btn-success:hover {
            background: linear-gradient(90deg, #ffcc33 0%, #ffb347 100%);
            color: #fff;
        }
        .btn-primary {
            background: linear-gradient(90deg, #7c4700 0%, #ffb347 100%);
            color: #fff;
            border: none;
        }
        .btn-primary:hover {
            background: linear-gradient(90deg, #ffb347 0%, #7c4700 100%);
            color: #fff;
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
            <i class="fa-solid fa-plus-circle"></i> Agregar Nuevo Producto
        </div>
        <%
        // Declaración de variables
        String codigo = request.getParameter("codigo");
        String nombre = request.getParameter("nombre");
        String descripcion = request.getParameter("descripcion");
        String precio = request.getParameter("precio");
        String stock = request.getParameter("stock");
        String categoria = request.getParameter("categoria");
        String mensaje = "";
        boolean exito = false;
        // Validación de errores en el lado del servidor
        String errorCodigo = "";
        String errorNombre = "";
        String errorDescripcion = "";
        String errorPrecio = "";
        String errorStock = "";
        String errorCategoria = "";
        boolean hayErrores = false;
        // Procesar el formulario solo si se ha enviado (método POST)
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            // Validar campo código
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
            // Validar campo nombre
            if (nombre == null || nombre.trim().isEmpty()) {
                errorNombre = "El nombre es obligatorio";
                hayErrores = true;
            } else if (nombre.trim().length() < 3) {
                errorNombre = "El nombre debe tener al menos 3 caracteres";
                hayErrores = true;
            }
            // Validar campo descripcion
            if (descripcion == null || descripcion.trim().isEmpty()) {
                errorDescripcion = "La descripción es obligatoria";
                hayErrores = true;
            }
            // Validar campo precio
            if (precio == null || precio.trim().isEmpty()) {
                errorPrecio = "El precio es obligatorio";
                hayErrores = true;
            } else {
                try {
                    Double.parseDouble(precio);
                } catch (NumberFormatException e) {
                    errorPrecio = "El precio debe ser un número válido";
                    hayErrores = true;
                }
            }
            // Validar campo stock
            if (stock == null || stock.trim().isEmpty()) {
                errorStock = "El stock es obligatorio";
                hayErrores = true;
            } else {
                try {
                    Integer.parseInt(stock);
                } catch (NumberFormatException e) {
                    errorStock = "El stock debe ser un número entero";
                    hayErrores = true;
                }
            }
            // Validar campo categoria
            if (categoria == null || categoria.trim().isEmpty()) {
                errorCategoria = "La categoría es obligatoria";
                hayErrores = true;
            }
            // Si no hay errores, proceder a guardar en la base de datos
            if (!hayErrores) {
                Connection conn = null;
                PreparedStatement ps = null;
                try {
                    // Obtener conexión a la base de datos
                    conn = DBConnection.getConnection();
                    // Verificar si el código ya existe en la base de datos
                    String queryVerificar = "SELECT COUNT(*) FROM producto WHERE codigo = ?";
                    ps = conn.prepareStatement(queryVerificar);
                    ps.setString(1, codigo.trim());
                    ResultSet rs = ps.executeQuery();
                    if (rs.next() && rs.getInt(1) > 0) {
                        // El código ya existe, mostrar error
                        errorCodigo = "Este código ya está registrado";
                        hayErrores = true;
                    } else {
                        // El código no existe, proceder a insertar
                        rs.close();
                        ps.close();
                        // Preparar consulta SQL de inserción
                        String queryInsertar = "INSERT INTO producto (codigo, nombre, descripcion, precio, stock, categoria, fecha_registro, hora_registro) VALUES (?, ?, ?, ?, ?, ?, CURDATE(), CURTIME())";
                        ps = conn.prepareStatement(queryInsertar);
                        ps.setString(1, codigo.trim());
                        ps.setString(2, nombre.trim());
                        ps.setString(3, descripcion.trim());
                        ps.setString(4, precio.trim());
                        ps.setString(5, stock.trim());
                        ps.setString(6, categoria.trim());
                        // Ejecutar la inserción
                        int resultado = ps.executeUpdate();
                        if (resultado > 0) {
                            mensaje = "Producto agregado correctamente";
                            exito = true;
                            // Limpiar campos después de una inserción exitosa
                            codigo = "";
                            nombre = "";
                            descripcion = "";
                            precio = "";
                            stock = "";
                            categoria = "";
                        } else {
                            mensaje = "Error al agregar el producto";
                        }
                    }
                } catch (SQLException e) {
                    if (e.getMessage().contains("Duplicate entry") && e.getMessage().contains("codigo")) {
                        errorCodigo = "Este código ya está registrado";
                        hayErrores = true;
                    } else {
                        mensaje = "Error de base de datos: " + e.getMessage();
                    }
                } finally {
                    try {
                        if (ps != null) ps.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
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
                <form action="add.jsp" method="POST" id="formAgregar" novalidate>
                    <!-- Campo código -->
                    <div class="mb-3">
                        <label for="codigo" class="form-label">
                            <i class="fa-solid fa-credit-card"></i>Código
                        </label>
                        <input type="text" class="form-control <%= errorCodigo.isEmpty() ? "" : "is-invalid" %>" 
                               id="codigo" name="codigo" value="<%= codigo != null ? codigo : "" %>" 
                               placeholder="Ingrese el código del producto" required>
                        <% if (!errorCodigo.isEmpty()) { %>
                            <div class="invalid-feedback"><%= errorCodigo %></div>
                        <% } %>
                        <div class="form-text">Ingrese solo números, sin puntos ni espacios</div>
                    </div>
                    <!-- Campo nombre -->
                    <div class="mb-3">
                        <label for="nombre" class="form-label">
                            <i class="fa-solid fa-person"></i>Nombre
                        </label>
                        <input type="text" class="form-control <%= errorNombre.isEmpty() ? "" : "is-invalid" %>" 
                               id="nombre" name="nombre" value="<%= nombre != null ? nombre : "" %>" 
                               placeholder="Ingrese el nombre del producto" required>
                        <% if (!errorNombre.isEmpty()) { %>
                            <div class="invalid-feedback"><%= errorNombre %></div>
                        <% } %>
                    </div>
                    <!-- Campo Descripción -->
                    <div class="mb-3">
                        <label for="descripcion" class="form-label">
                            <i class="fa-solid fa-info-circle"></i>Descripción
                        </label>
                        <input type="text" class="form-control <%= errorDescripcion.isEmpty() ? "" : "is-invalid" %>" 
                               id="descripcion" name="descripcion" value="<%= descripcion != null ? descripcion : "" %>" 
                               placeholder="Ingrese la descripción del producto" required>
                        <% if (!errorDescripcion.isEmpty()) { %>
                            <div class="invalid-feedback"><%= errorDescripcion %></div>
                        <% } %>
                    </div>
                    <!-- Campo Precio -->
                    <div class="mb-3">
                        <label for="precio" class="form-label">
                            <i class="fa-solid fa-dollar-sign"></i>Precio
                        </label>
                        <input type="text" class="form-control <%= errorPrecio.isEmpty() ? "" : "is-invalid" %>" 
                               id="precio" name="precio" value="<%= precio != null ? precio : "" %>" 
                               placeholder="Ingrese el precio del producto" required>
                        <% if (!errorPrecio.isEmpty()) { %>
                            <div class="invalid-feedback"><%= errorPrecio %></div>
                        <% } %>
                    </div>
                    <!-- Campo Stock -->
                    <div class="mb-3">
                        <label for="stock" class="form-label">
                            <i class="fa-solid fa-box"></i>Stock
                        </label>
                        <input type="text" class="form-control <%= errorStock.isEmpty() ? "" : "is-invalid" %>" 
                               id="stock" name="stock" value="<%= stock != null ? stock : "" %>" 
                               placeholder="Ingrese el stock del producto" required>
                        <% if (!errorStock.isEmpty()) { %>
                            <div class="invalid-feedback"><%= errorStock %></div>
                        <% } %>
                    </div>
                    <!-- Campo Categoría -->
                    <div class="mb-3">
                        <label for="categoria" class="form-label">
                            <i class="fa-solid fa-tags"></i>Categoría
                        </label>
                        <input type="text" class="form-control <%= errorCategoria.isEmpty() ? "" : "is-invalid" %>" 
                               id="categoria" name="categoria" value="<%= categoria != null ? categoria : "" %>" 
                               placeholder="Ingrese la categoría del producto" required>
                        <% if (!errorCategoria.isEmpty()) { %>
                            <div class="invalid-feedback"><%= errorCategoria %></div>
                        <% } %>
                    </div>
                    <!-- Botones de acción -->
                    <div class="d-flex justify-content-between mt-4">
                        <a href="../index.jsp" class="btn btn-secondary">
                            <i class="fa-solid fa-arrow-left"></i>Cancelar
                        </a>
                        <button type="submit" class="btn btn-primary">
                            <i class="fa-solid fa-save"></i>Guardar
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
