# 2024-ps1-chest_x_ray-backend

## Setup
1. Install MySQL (lot of guides/tutorials online) - **[Remember the username and password]**
2. create a file called `keyconfig.py` in the `chest_xray` folder.
3. Inside `keyconfig.py` input:
    ```
    DB_USER = your_username
    DB_PASSWORD = your_password
    ```
4. Open mysql and **create a database** called `chest_xray`
5. Make sure you have a virtual environment setup and **activated**.
6. install requirement.txt using
    ```
    pip install -r requirements.txt
    ```

7. Migrate to the database using:
    ```
    python manage.py makemigrations
    python manage.py migrate
    ```

8. Run the server!
    ```
    python manage.py runserver
    ```