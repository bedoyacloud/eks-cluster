from django.shortcuts import render

# Create your views here.

orders_list = []

def place_order(request):
    if request.method == 'POST':
        pizza_type = request.POST.get('pizza_type')
        comments = request.POST.get('comments')
        orders_list.append({'pizza_type': pizza_type, 'comments': comments})
    return render(request, 'orders/place_order.html', {'orders': orders_list})