import '../../domain/entities/producto.dart';
import '../../domain/repositories/producto_repository.dart';
import '../datasources/producto_local_datasource.dart';
import '../datasources/servicio_asincrono_simulado.dart';

class ProductoRepositoryImpl implements ProductoRepository {
  ProductoRepositoryImpl(this._dataSource, this._servicio);

  final ProductoLocalDataSource _dataSource;
  final ServicioAsincronoSimulado _servicio;

  @override
  Future<List<Producto>> obtenerTodos() {
    return _servicio.conLatencia(_dataSource.obtenerProductos);
  }
}
