# Research Feedback: GPU Sharing on Amazon EKS with NVIDIA Time Slicing
## Overview
Amazon EKS now supports GPU sharing using NVIDIA Time Slicing (MPS - Multi-Process Service), a feature designed to improve GPU utilization for workloads that don’t require full GPU resources. NVIDIA Time Slicing allows multiple containers or pods to share a single GPU while maintaining high performance and isolation, enabling cost-efficient scaling for GPU-intensive workloads such as AI inference.

## Benefits of GPU Sharing with NVIDIA Time Slicing
1. Cost Efficiency:
    - Maximize GPU utilization by sharing GPUs across multiple workloads.
    - Reduce the need for multiple GPU instances.
2. Flexibility:
    - Supports diverse workloads (AI/ML, rendering, etc.) with varying GPU demands.
3. Integration with EKS and Karpenter:
    Seamlessly integrates with Kubernetes scheduling, including Karpenter for dynamic autoscaling.

## Customer Implementation Recommendations
1. Enable NVIDIA Time Slicing:
    - Use NVIDIA MPS (Multi-Process Service) for GPU sharing.
    - Available on accelerated EC2 instances like p4, p3, g4, and g5.
2. Install NVIDIA GPU Plugin:
    - Use the NVIDIA Kubernetes Device Plugin to manage GPU resources and configure time slicing.
3. Optimize Workloads:
    - Adapt applications to leverage shared GPUs efficiently.

## Feasibility with Karpenter
Karpenter can be configured to support GPU sharing by setting appropriate resource requests (nvidia.com/gpu) and dynamically scaling GPU-enabled nodes based on workload requirements.