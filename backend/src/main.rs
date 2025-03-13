use axum::{
    routing::get,
    Router,
};

#[tokio::main]
async fn main() {
    let port = 8000;
    println!("Starting server on port {}", port);

    let app = Router::new()
        .route("/", get(handler));

    let listener = tokio::net::TcpListener::bind(format!("0.0.0.0:{}", port))
        .await
        .unwrap();
    println!("listening on {}", listener.local_addr().unwrap());
    axum::serve(listener, app).await.unwrap();
}

async fn handler() -> &'static str {
    "Hello from Pondera Backend!"
}