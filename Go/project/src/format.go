type RawBytes
type Result
type DB
	func Open(driverName, dataSourceName string) (*DB, error)
	func (db *DB) Driver() driver.Driver
	func (db *DB) Ping() error
	func (db *DB) Close() error
	func (db *DB) SetMaxOpenConns(n int)
	func (db *DB) SetMaxIdleConns(n int)
	func (db *DB) Exec(query string, args ...interface{}) (Result, error)
	func (db *DB) Query(query string, args ...interface{}) (*Rows, error)
	func (db *DB) QueryRow(query string, args ...interface{}) *Row
	func (db *DB) Prepare(query string) (*Stmt, error)
	func (db *DB) Begin() (*Tx, error)
type Row
	func (r *Row) Scan(dest ...interface{}) error
type Rows
	func (rs *Rows) Columns() ([]string, error)
	func (rs *Rows) Scan(dest ...interface{}) error
	func (rs *Rows) Next() bool
	func (rs *Rows) Close() error
	func (rs *Rows) Err() error
type Stmt
	func (s *Stmt) Exec(args ...interface{}) (Result, error)
	func (s *Stmt) Query(args ...interface{}) (*Rows, error)
	func (s *Stmt) QueryRow(args ...interface{}) *Row
	func (s *Stmt) Close() error
type Tx
	func (tx *Tx) Exec(query string, args ...interface{}) (Result, error)
	func (tx *Tx) Query(query string, args ...interface{}) (*Rows, error)
	func (tx *Tx) QueryRow(query string, args ...interface{}) *Row
	func (tx *Tx) Prepare(query string) (*Stmt, error)
	func (tx *Tx) Stmt(stmt *Stmt) *Stmt
	func (tx *Tx) Commit() error
	func (tx *Tx) Rollback() error
	func Register(name string, driver driver.Driver)