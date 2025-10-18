from django.shortcuts import render
from django.http import HttpResponse
from django.views.decorators.csrf import csrf_exempt
import time

def home(request):
    return render(request, 'home.html')

# This view is intentionally vulnerable to R.U.D.Y. attacks
@csrf_exempt
def vulnerable_form(request):
    if request.method == 'POST':
        # Process the form data (inefficiently to increase vulnerability)
        large_data = request.POST.get('large_field', '')
        
        # Simulate processing time that increases with data size
        # This makes the vulnerability more pronounced
        processing_time = min(len(large_data) / 1000000, 10)  # Cap at 10 seconds
        time.sleep(processing_time)
        
        # Store data in memory (another resource consumption vector)
        processed_data = large_data.upper()
        
        return HttpResponse(f"Data processed: {len(processed_data)} characters")
    
    # Render a form with a large text field that encourages big payloads
    return render(request, 'vulnerable_form.html')

# Additional vulnerable endpoint with no rate limiting
@csrf_exempt
def upload_endpoint(request):
    if request.method == 'POST':
        # Accept large file uploads without size limits
        uploaded_file = request.FILES.get('file_upload', None)
        if uploaded_file:
            # Read entire file into memory (inefficient)
            file_content = uploaded_file.read()
            
            # Simulate heavy processing
            time.sleep(min(len(file_content) / 1000000, 5))
            
            return HttpResponse(f"File processed: {len(file_content)} bytes")
    
    # Form with file upload field
    return render(request, 'upload_form.html')
