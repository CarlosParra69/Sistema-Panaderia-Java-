
package sena.adso.config;

/**
 *
 * @author Carlos Parra
 */
public class ErrorManager {
    /**
     * Obtiene un mensaje de error amigable para un error de base de datos.
     * 
     * @param exception La excepción original
     * @return Mensaje de error formateado para mostrar al usuario
     */
    public static String getDatabaseErrorMessage(Exception exception) {
        String message = exception.getMessage();
        
        // Errores comunes de MySQL
        if (message.contains("Access denied for user")) {
            return "Error de acceso a la base de datos: Credenciales incorrectas.";
        } else if (message.contains("Communications link failure")) {
            return "Error de conexión: No se pudo establecer conexión con la base de datos.";
        } else if (message.contains("Duplicate entry") && message.contains("for key")) {
            if (message.contains("DI")) {
                return "El documento de identidad (DI) ya existe en el sistema.";
            } else {
                return "Ya existe un registro con los mismos datos únicos.";
            }
        } else if (message.contains("Table") && message.contains("doesn't exist")) {
            return "Error de estructura: La tabla requerida no existe en la base de datos.";
        } else if (message.contains("Unknown database")) {
            return "Error de configuración: La base de datos especificada no existe.";
        }
        
        // Mensaje general para otros errores
        return "Error en la base de datos: " + message;
    }
    
    /**
     * Obtiene un mensaje de error amigable para un error de validación.
     * 
     * @param field Campo que causó el error
     * @param value Valor que causó el error
     * @param type Tipo de error (format, required, length, etc.)
     * @return Mensaje de error formateado para mostrar al usuario
     */
    public static String getValidationErrorMessage(String field, String value, String type) {
        switch (field.toLowerCase()) {
            case "di":
                if ("required".equals(type)) {
                    return "El Documento de Identidad es obligatorio.";
                } else if ("format".equals(type)) {
                    return "El formato del DI es incorrecto. Solo debe contener números.";
                } else if ("length".equals(type)) {
                    return "El DI debe tener entre 5 y 15 caracteres.";
                } else if ("duplicate".equals(type)) {
                    return "Este DI ya está registrado en el sistema.";
                }
                break;
                
            case "nombres":
                if ("required".equals(type)) {
                    return "El nombre es obligatorio.";
                } else if ("length".equals(type)) {
                    return "El nombre debe tener al menos 3 caracteres.";
                } else if ("format".equals(type)) {
                    return "El nombre contiene caracteres no permitidos.";
                }
                break;
                
            default:
                if ("required".equals(type)) {
                    return "El campo " + field + " es obligatorio.";
                } else if ("format".equals(type)) {
                    return "El formato del campo " + field + " es incorrecto.";
                }
        }
        
        return "Error de validación en el campo " + field;
    }
    
    /**
     * Valida si una cadena contiene solo dígitos.
     * 
     * @param str Cadena a validar
     * @return true si la cadena solo contiene dígitos, false en caso contrario
     */
    public static boolean isNumeric(String str) {
        if (str == null || str.isEmpty()) {
            return false;
        }
        return str.matches("\\d+");
    }
    
    /**
     * Limpia una cadena de entrada para prevenir inyección SQL.
     * 
     * @param input Cadena de entrada
     * @return Cadena sanitizada
     */
    public static String sanitizeInput(String input) {
        if (input == null) {
            return "";
        }
        // Eliminar caracteres potencialmente peligrosos
        return input.replaceAll("[;'\"\\\\]", "");
    }
}
