import pytest
from application import application as flask_app

@pytest.fixture
def app():
    yield flask_app

@pytest.fixture
def client(app):
    return app.test_client()

def test_ci_cd_pipeline(client):
    response = client.get('/')
    assert response.status_code == 200
    assert b'Your CI-CD Pipeline Works!' in response.data