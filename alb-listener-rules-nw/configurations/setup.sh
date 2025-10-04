#!/bin/bash
# Update packages
yum update -y

# Install httpd
yum install -y httpd

# Create directory for dashboard
mkdir -p /var/www/html/fardeen/path1

# Create a beautiful HTML dashboard
cat > /var/www/html/fardeen/path1/index.html <<'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Fardeen's Dashboard</title>
  <style>
    body {
      background: linear-gradient(135deg, #667eea, #764ba2);
      font-family: Arial, sans-serif;
      color: #fff;
      text-align: center;
      padding: 50px;
    }
    h1 {
      font-size: 3em;
      margin-bottom: 20px;
    }
    .card {
      background: rgba(255, 255, 255, 0.1);
      border-radius: 12px;
      padding: 20px;
      margin: 20px auto;
      max-width: 600px;
      box-shadow: 0 8px 20px rgba(0,0,0,0.2);
    }
  </style>
</head>
<body>
  <h1>🚀 Welcome to Fardeen's Dashboard 🚀</h1>
  <div class="card">
    <p>This is your custom Apache-hosted dashboard.</p>
    <p>Deployed automatically with Terraform + UserData 🎉</p>
  </div>
</body>
</html>
EOF

# Start & enable httpd
systemctl start httpd
systemctl enable httpd
