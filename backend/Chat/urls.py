# chats/urls.py
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import *
from .views import ListMessageView

# router = DefaultRouter()
# router.register(r'chatss', ChatViewSet)
# router.register(r'messages', MessageViewSet)

# urlpatterns = [
#     path('chatsss', include(router.urls)),
# ]

urlpatterns=[
    path('get_message/',ListMessageView.as_view(), name='chatview'),
    path('create_chat/',ChatCreateView.as_view(), name='chat_view'),
    path('create_message/',MessageCreateView.as_view(), name='message_view')
    # path('messages/',MessageViewSet.as_view({
    #     'get': 'retrieve',
    #     'put': 'update',
    #     'patch': 'partial_update',
    #     'delete': 'destroy',
    # }), name='messageview'),
]